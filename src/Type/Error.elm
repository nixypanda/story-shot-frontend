module Type.Error exposing (
  Error
  , decode
  , extractMsg
  )

import Json.Decode as JD
import Json.Decode.Extra exposing ((|:))



-- MODEL

type alias Error =
  { id : Maybe String
  , code : Maybe String
  , meta : Maybe String
  , status : Maybe String
  , title : Maybe String
  , detail : Maybe String
  }


decode : JD.Decoder Error
decode =
  JD.succeed Error
  |: (JD.field "id" (JD.nullable JD.string))
  |: (JD.field "code" (JD.nullable JD.string))
  |: (JD.field "meta" (JD.nullable JD.string))
  |: (JD.field "status" (JD.nullable JD.string))
  |: (JD.field "title" (JD.nullable JD.string))
  |: (JD.field "detail" (JD.nullable JD.string))


extractMsg : Error -> String
extractMsg err =
  case (err.title, err.detail) of
    (Nothing, Nothing) -> ""
    (Nothing, Just m) -> m
    (Just t, Nothing) -> t
    (Just t, Just m) -> String.concat [t, "! ", m]
