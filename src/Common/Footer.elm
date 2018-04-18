{-
   This module represents the footer of the main site. The footer in this case displays informaion
   a brief about the author and his social media links.
 -}

module Common.Footer exposing (footer_)

import Element exposing (..)
import Element.Attributes exposing (..)

import Type.Style as TS


{-
   The footer (has two parts a top part, and a bottom part)
 -}
footer_ : Element TS.StyleClass variation msg
footer_ =
  column TS.NoStyle []
    [ topLine
    , bottomLine
    ]


-- TOP PORTION OF THE FOOTER

{-
   The top portion of the footer.
   * Shows a quote related to the app
 -}
topLine : Element TS.StyleClass variation msg
topLine =
  let
    quote =
      "A reader lives a thousand lives before he dies. The man who never reads lives only one."
    author =
      "George R.R. Martin"
  in
    row TS.TopFooterStyle [width fill, center]
      [ row TS.TopFooterStyle [width fill, maxWidth <| TS.maxWidth, alignRight, paddingXY 0 30]
        [ column TS.NoStyle [alignRight]
          [ el TS.AuthorStyle [] <| text quote
          , el TS.NoStyle [] <| text author
          ]
        ]
      ]


-- THE BOTTOM PORTION OF THE FOOTER

{-
   This just displays a bar at the very bottom of the site which displays
   * Name of the application
   * and the ever popular coded with love tagline.
 -}
bottomLine : Element TS.StyleClass variation msg
bottomLine =
  row TS.BottomFooterStyle [center, width fill]
  [ row TS.NoStyle [width fill, maxWidth <| TS.maxWidth, spread, paddingXY 0 15]
      [ el TS.NoStyle [] <| text "Story Shot"
      , el TS.NoStyle [] <| text "</> with ♥ by Sherub Thakur"
      ]
      ]

