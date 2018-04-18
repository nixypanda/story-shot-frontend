module Main exposing (main)

import Navigation as Nav
import Json.Decode exposing (Value)

import Type.Route as TR
import App as A


-- Main Driver

main : Program Value A.Model A.Msg
main =
  Nav.programWithFlags (TR.parseLocation >> A.SetRoute)
    { init = A.init
    , view = A.view
    , update = A.update
    , subscriptions = A.subscriptions
    }

