module App exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Element.Attributes exposing (..)
import Window
-- import Http
import Navigation
import Json.Decode as JD
import Task

import Ports

import Common.Topbar as Topbar
import Common.Footer as CF
import Common.Utils as CU exposing ((=>))

import Route.Home as Home
import Route.FourOFour as FourOFour
import Route.Read as Read
-- import Route.Write as Write
import Route.Login as Login

-- import Type.Model as TM
-- import Type.Action as TA
import Type.Style as TS
import Type.Session as Session
-- import Type.Story as TStory
import Type.Route as Route



-- UPDATE 


type Page
  = Blank
  | NotFound
  | Errored 
  | Home
  | Login Login.Model
  | Write
  | Read Read.Model
  | Register


type PageState
 = Loaded Page
 | TransitioningFrom Page


getPage : PageState -> Page
getPage pageState =
  case pageState of
    Loaded page ->
      page

    TransitioningFrom page ->
      page



type alias Model =
  { session : Maybe Session.Session
  , pageState : PageState
  , screen : Window.Size
  , apiBaseUrl : String
  , topbarModel : Topbar.Model
  }


initialPage : Page
initialPage = Blank


decodeSessionFromJson : JD.Value -> Maybe Session.Session
decodeSessionFromJson json =
  json
    |> JD.decodeValue JD.string
    |> Result.toMaybe
    |> Maybe.andThen (JD.decodeString Session.decode >> Result.toMaybe)



init : JD.Value -> Navigation.Location -> (Model, Cmd Msg)
init val location =
  setRoute (Route.parseLocation location)
    { session = decodeSessionFromJson val
    , pageState = Loaded initialPage
    , screen = {width = 0, height = 0}
    , apiBaseUrl = "http://localhost:8081"
    , topbarModel = Topbar.init
    }


-- -- VIEW --

renderPage : Model -> Page -> Element TS.StyleClass variation Msg
renderPage model page =
  case page of
    Blank -> FourOFour.view
    NotFound -> FourOFour.view
    Errored  -> FourOFour.view
    Home ->
      Home.view model.screen

    Login subModel ->
      Login.view subModel
        |> Element.map LoginMsg

    Write -> FourOFour.view

    Read subModel ->
      Read.view subModel
      |> Element.map ReadMsg

    Register -> FourOFour.view


view : Model -> Html Msg
view model =
  let
    renderedPage =
      case model.pageState of
        Loaded page ->
          renderPage model page

        TransitioningFrom page ->
          renderPage model page
  in
  layout TS.sheet <|
    el TS.AppStyle [] <|
      column TS.NoStyle [minHeight << px << toFloat <| model.screen.height]
        [ el TS.NoStyle [height fill]
          (Topbar.view model.topbarModel model.session |> Element.map TopbarWrapper)
        , column TS.NoStyle [height <| fillPortion 8] [renderedPage]
        , el TS.NoStyle [alignBottom, height fill] CF.footer_
        ]



-- UPDATE

type Msg
  = SetRoute Route.Route
  | LoginMsg Login.Msg
  | SetSession (Maybe Session.Session)
  | ReadMsg Read.Msg
  | SetWinSize Window.Size
  | TopbarWrapper Topbar.Msg


setRoute : Route.Route -> Model -> (Model, Cmd Msg)
setRoute route model =
  case route of
    Route.Home ->
      {model | pageState = Loaded Home}
      => Task.perform SetWinSize Window.size

    Route.FourOFour ->
      model => Cmd.none

    Route.Read ->
      let
        (subModel, cmd) = Read.init model.apiBaseUrl
      in
        { model | pageState = Loaded (Read subModel) }
        => Cmd.batch
          [ Task.perform SetWinSize Window.size
          , Cmd.map ReadMsg cmd
          ]

    Route.Write ->
      model => Cmd.none

    Route.Login ->
      { model | pageState = Loaded (Login Login.initialModel) }
      => Task.perform SetWinSize Window.size

    Route.Register ->
      model => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SetWinSize screen ->
      ({model | screen = screen}, Cmd.none)
    
    _ ->
      updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> (Model, Cmd Msg)
updatePage route msg model =
  case (msg, route) of
    (SetRoute r, _) ->
      setRoute r model

    (SetSession ms, _) ->
      let
        cmd = if ms == Nothing then Route.modifyUrl Route.Home else Cmd.none
      in
        { model | session = ms }
        => cmd

    (TopbarWrapper subMsg, _) ->
      let
        topbarModel = Topbar.update subMsg model.topbarModel
      in
        { model | topbarModel = topbarModel}
        => Cmd.none

    (LoginMsg subMsg, Login subModel) ->
      let
        ((pageModel, cmd), msgFromPage) =
          Login.update subMsg subModel

        newModel =
          case msgFromPage of
            Login.NoOp ->
              model

            Login.SetSession session ->
              { model | session = session }
      in
          { newModel | pageState = Loaded (Login pageModel) }
          => Cmd.map LoginMsg cmd

    (ReadMsg subMsg, Read subModel) ->
      let
        (pageModel, cmd) = Read.update subMsg subModel
      in
        {model | pageState = Loaded (Read pageModel)}
        => Cmd.none

    -- Disregard incoming messages that arrived for the wrong page
    ( _, _ ) -> model => Cmd.none


-- SUBCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Window.resizes SetWinSize
    , Sub.map SetSession sessionChange
    ]

sessionChange : Sub (Maybe Session.Session)
sessionChange =
  Ports.onSessionChange (JD.decodeValue Session.decode >> Result.toMaybe)
