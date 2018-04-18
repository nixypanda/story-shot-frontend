module Type.Route exposing (
  Route(..)
  , parseLocation
  , modifyUrl
  , href
  )

import Maybe as Maybe
import UrlParser as Url
import Navigation as Nav
import Element


type Route
  = Home
  | Read
  | Write
  | FourOFour
  | Login
  | Register


href : Route -> Element.Element s v m  -> Element.Element s v m
href route elm =
  Element.link (route |> reverseRoute) elm


modifyUrl : Route -> Cmd msg
modifyUrl =
  reverseRoute >> Nav.modifyUrl


parseLocation : Nav.Location -> Route
parseLocation location =
  if String.isEmpty location.pathname then
    Home
  else
    Maybe.withDefault FourOFour (Url.parsePath route location)


-- HELPERS

route : Url.Parser (Route -> a) a
route =
  Url.oneOf
  [ Url.map Home (Url.s "")
  , Url.map Read (Url.s "read")
  , Url.map Write (Url.s "write")
  , Url.map Login (Url.s "login")
  , Url.map Register (Url.s "register")
  ]


reverseRoute : Route -> String
reverseRoute route =
  case route of
    Home ->
      "/"

    FourOFour ->
      ""

    Read ->
      "/read"

    Write ->
      "/write"

    Login ->
      "/login"

    Register ->
      "/register"

