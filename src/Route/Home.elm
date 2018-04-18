module Route.Home exposing (
  view
  )


import Element exposing (..)
import Element.Attributes exposing (..)
import Window

import Type.Style as TS
import Type.Route as Route



-- MODEL

type alias Header =
  { header : String
  , pronunciation : String
  , type__ : String
  , description : String
  , uses : List String
  }


type alias Tile =
  { icon : String
  , header : String
  , description : String
  }



-- VIEW

header : TS.StyleClass -> List (Attribute variation msg) -> Window.Size -> Header -> Element TS.StyleClass variation msg
header style layout screenSize data =
  let
      contentWidth = width <| percent <| if screenSize.width > 1000 then 50 else 100
  in
    column style (layout ++ [minWidth <| px 500, contentWidth, paddingXY 10 100])
    [ h2 TS.H2Style [] <| text data.header
    , h3 TS.H3Style [] <| text data.pronunciation
    , el TS.NoStyle [] <| text data.type__
    , el TS.NoStyle [] <| text data.description
    , column TS.NoStyle layout (List.map (el TS.NoStyle [] << text) data.uses)
    ]


cta : Element TS.StyleClass variation msg
cta =
  Route.href Route.Read <|
    el TS.NoStyle [] <| text "Read a Random Story"


tile : Tile -> Element TS.StyleClass variation msg
tile data =
  column TS.NoStyle [maxWidth (px 300)]
    [ h3 TS.H3Style [class data.icon, center] empty
    , h4 TS.H4Style [center] <| text data.header
    , paragraph TS.NoStyle [center] [text data.description]
    ]


view : Window.Size -> Element TS.StyleClass variation msg
view screen =
  column TS.NoStyle []
  [ wrappedRow TS.NoStyle []
    [ header TS.HomeHeaderLeftStyle [alignRight] screen leftHeader
    , header TS.HomeHeaderRightStyle [alignLeft] screen rightHeader
    ]
    , el TS.NoStyle [paddingXY 0 20] <| el TS.HomeCTAStyle [center, padding 20] cta
  , wrappedRow TS.NoStyle [center, padding 20, spacing 20]
    (List.map tile tiles)
  ]



-- DATA

leftHeader : Header
leftHeader =
  {header = "story"
  , pronunciation = "/ˈstɔːri/"
  , type__ = "noun"
  , description = "an account of imaginary or real people and events told for entertainment."
  , uses =
    [ "an adventure story"
    , "tale, narrative, account, recital"
    ]
  }

rightHeader : Header
rightHeader =
  { header = "shot"
  , pronunciation = "/ʃɒt/"
  , type__ = "noun"
  , description = "a small drink of spirits."
  , uses =
    [ "he took a shot of whiskey"
    , "jab, fix, hype"
    ]
  }


tiles : List Tile
tiles =
  [ { icon = "fa fa-cog"
    , header = "How does it work?"
    , description = "StoryShot is an ongoing project that promotes reading in your spare time. The app generates a random short story based on your reading time selection..."
    }
  , { icon = "fa fa-search"
    , header = "Bored?"
    , description = "Click the button and surprise yourself with a random short story!"
    }
  , { icon = "fa fa-thumbs-up"
    , header = "Like the idea?"
    , description = "Connect with us on Facebook, like and follow! We would love to hear from you. Visit our FB Page"
    }
  ]
