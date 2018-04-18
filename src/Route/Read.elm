module Route.Read exposing (
    Model
  , Msg
  , init
  , view
  , update
  )


import Element exposing (..)
import Http
import Json.Decode as JD


import Type.Style as TS
import Type.Story as TStory
import Common.Utils as CU exposing ((=>))
import APIBase as AB



-- MODEL

type StoryLoadStatus
  = NoOp
  | Loading
  | Loaded
  | LoadError


type alias Model =
  { status : StoryLoadStatus
  , error : String
  , story : Maybe TStory.Story
  }


init : String -> (Model, Cmd Msg)
init apiBase =
  { status = NoOp
  , error = ""
  , story = Nothing
  }
  => initialStoryFetch


-- UPDATE

type Msg
  = LoadStory
  | MapStoryResult (Result Http.Error TStory.Story)


initialStoryFetch : Cmd Msg
initialStoryFetch =
  let
    url : String
    url = AB.apiBase ++ "/story/random?include=author,tag"

    request : Http.Request TStory.Story
    request = Http.get url (JD.at ["data"] TStory.decode)
  in
    Http.send MapStoryResult request



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoadStory ->
      ( {model | status = Loading}
      , initialStoryFetch
      )

    MapStoryResult (Ok story_) ->
      ( { model | status = Loaded, story = Just story_ }
      , Cmd.none
      )

    MapStoryResult (Err err) ->
      ( { model | status = LoadError, error = (CU.errorMapper err) }
      , Cmd.none
      )



-- VIEW 

maybeStory : Maybe TStory.Story -> Element TS.StyleClass variation msg
maybeStory s =
  case s of
    Nothing  ->
      el TS.NoStyle [] empty

    Just storyShot ->
      TStory.story storyShot


view : Model -> Element TS.StyleClass variation msg
view model =
  let
    content =
      case model.status of
        NoOp ->
          el TS.NoStyle [] empty

        Loading ->
          el TS.NoStyle [] <| text "Loading"

        Loaded ->
          el TS.NoStyle [] <| maybeStory model.story

        LoadError ->
          el TS.NoStyle [] <| text "Load Error"
  in
    content
