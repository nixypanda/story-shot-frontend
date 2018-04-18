module Type.Story exposing (Story, decode, story)

import Element exposing (..)
import Element.Attributes exposing (..)
import Time.DateTime as DT
import Json.Decode as JD
import Json.Decode.Extra exposing ((|:))
import Either as E
import Either.Decode as ED
import Markdown as MD

import Common.Utils as CU
import Type.Style as TS
import Type.Genre as TG
import Type.Duration as TD
import Type.Author as TA
import Type.Tag as TT
import Type.BaseResource as TB



-- MODEL

{-
  The story
 -}
type alias Story =
  { id : Int
  , title : String
  , author : E.Either (List TA.Author) (List TB.Base)
  , timesRead : Int
  , stars : Int
  , genre : TG.Genre
  , tags : E.Either (List TT.Tag) (List TB.Base)
  , story : String
  , type_ : String
  , link : String
  , updatedAt : DT.DateTime
  , createdAt : DT.DateTime
  }


{-
  Decode a story json.
  (Makes use of the read methods declared for `TD.Duration` and `TG.Genre`)
  Equivalent to making it an instance of FromJSON
 -}
decode : JD.Decoder Story
decode =
  JD.succeed Story
    |: (JD.field "id" JD.int)
    |: (JD.field "title" JD.string)
    |: (JD.field "authors" (ED.either (JD.list TA.decode) (JD.list TB.decode)))
    |: (JD.field "read-count" JD.int)
    |: (JD.field "stars" JD.int)
    |: (JD.field "genre" TG.decode)
    |: (JD.field "tags" (ED.either (JD.list TT.decode) (JD.list TB.decode)))
    |: (JD.field "story" JD.string)
    |: (JD.field "type" JD.string)
    |: (JD.field "link" JD.string)
    |: (JD.field "updated-at" CU.decodeTS)
    |: (JD.field "created-at" CU.decodeTS)


-- VIEW

{-
   How to render a story on the screen.
 -}
story : Story -> Element TS.StyleClass variation msg
story s =
  row TS.NoStyle [padding 50, center, width fill]
  [ column TS.NoStyle [spacing 20, maxWidth <| px 1000, alignLeft, minWidth <| px 999]
      [ title s.title
      , authors s.author
      , tagView s.tags
      , wrappedRow TS.NoStyle [width fill, spread]
        [ shotLine s.story s.genre
        , starView s.stars
        ]
      , theStory (s.story)
      , readCount s.timesRead
      ]
  ]


-- Display the title of the story
title : String -> Element TS.StyleClass variation msg
title t =
  h1 TS.H1Style [] <| text t


-- Display the author of the story
authors : E.Either (List TA.Author) (List TB.Base) -> Element TS.StyleClass variation msg
authors eitherAuthorOrBase =
  case eitherAuthorOrBase of
    E.Left [author] ->
      el TS.AuthorStyle [] <| text <| "by " ++ author.name

    E.Left authors ->
      let
        f authors = case authors of
          [] -> "a very shy guy/gal"
          [a] -> a.name
          [a1, a2] -> a1.name ++ " and " ++ a2.name
          (a::ass) -> a.name ++ ", " ++ f ass
      in
        el TS.AuthorStyle [] <| text <| "by " ++ f authors

    E.Right base ->
      el TS.NoStyle [] empty


-- Display the story itself.
-- should store as markdown and the convert here
theStory : String -> Element TS.StyleClass variation msg
theStory s =
  let
      story = MD.toHtml [] s
  in
    el TS.NoStyle [] <| html story


-- Display the meta info of the story
starView : Int -> Element TS.StyleClass variation msg
starView stars =
  el TS.NoStyle [] <| text <| toString stars


tagView : E.Either (List TT.Tag) (List TB.Base) -> Element TS.StyleClass variation msg
tagView eitherTagOrBaseList =
  case eitherTagOrBaseList of
    E.Left tagList ->
      wrappedRow TS.NoStyle []
        (List.map (el TS.PillStyle [padding 5] << text << .name) tagList)

    E.Right baseList ->
      el TS.NoStyle [] empty


readCount : Int -> Element TS.StyleClass variation msg
readCount count =
  let
      line = "This shot has been taken " ++ toString count ++ " times."
  in
    el TS.AuthorStyle [] <| text line


shotLine : String -> TG.Genre -> Element TS.StyleClass variation msg
shotLine story genre = 
  let
      len = String.length story
      duration = if len < 500 then TD.Short
      else if len < 5000 then
        TD.Medium
      else
        TD.Long
  in
    el TS.NoStyle [] <| text <|
      "You are taking a "
      ++ toString (duration)
      ++ " "
      ++ toString (genre)
      ++ " shot."
