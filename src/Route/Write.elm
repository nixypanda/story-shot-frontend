module Route.Write exposing (view)


import Element exposing (..)
import Element.Attributes exposing (..)

import Type.Model as TM
import Type.Style as TS


view : TM.Model -> Element TS.StyleClass variation msg
view model =
  row TS.NoStyle [padding 50, center, width fill]
  [ column TS.NoStyle [spacing 20, maxWidth <| TS.maxWidth, alignLeft, minWidth <| px 999]
    [ el TS.NoStyle [] <| text "Write up bitch"
    ]
  ]
