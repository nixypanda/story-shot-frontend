module Common.Topbar exposing (
  Model
  , Msg
  , init
  , update
  , view
  )


import Either exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)

import Type.Style as TS
import Type.Route as Route
import Type.Session as Session


type alias Model = 
  { showLoginDropdown : Bool
  }


init : Model
init =
  { showLoginDropdown = False
  }


type Msg
  = ToggleLoginDropdown


update : Msg -> Model -> Model
update msg model =
  case msg of
    ToggleLoginDropdown ->
      {model | showLoginDropdown = not model.showLoginDropdown}


{-
   Just display a topbar.
   * The name of the application
   * Some description.
-}
view : Model -> Maybe Session.Session -> Element TS.StyleClass variation Msg
view model msession =
  row TS.NavBarStyle [width fill, padding 50, verticalCenter, center ]
  [ column TS.NoStyle [width fill, maxWidth <| TS.maxWidth]
    [ h1 TS.HeaderStyle [] <| text "Story Shot"
    , el TS.NoStyle [] <| text "A shot of a story anytime/anywhere"
    ]
    , case msession of
        Nothing -> login
        Just s -> profile model s
  ]


login : Element TS.StyleClass variation msg
login =
  Route.href Route.Login <|
    button TS.TopbarLoginButton [center, paddingXY 10 5] <| text "Login"


profile : Model -> Session.Session -> Element TS.StyleClass variation Msg
profile model session =
  case session.user of
    (Left user) ->
      let
          profileButton = 
            el TS.TopbarLoginButton [alignRight, paddingXY 10 5, minWidth (px 200), onClick ToggleLoginDropdown]
              (text user.name)
      in
        case model.showLoginDropdown of
          True ->
            profileButton
              |> below
                [ column TS.TopbarLoginDropdown [paddingXY 10 5, spacing 5]
                  [ el TS.H4Style [] <| text user.name
                  , el TS.NoStyle [] <| text <| "@" ++ user.username
                  ]
                ]
          False ->
            profileButton

    (Right base) ->
      el TS.NoStyle [] empty
