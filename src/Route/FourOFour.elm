module Route.FourOFour exposing (view)

import Element exposing (..)
import Type.Style as TS


view : Element TS.StyleClass variation msg
view =
  el TS.NoStyle [] <| text "NOT FOUND"
