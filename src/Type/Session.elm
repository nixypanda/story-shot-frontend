module Type.Session exposing (
    Session
  , decode
  , encode
  )

import Either exposing (..)

import Time.DateTime as DT
import Json.Decode as JD
import Json.Encode as JE
import Json.Decode.Extra exposing ((|:))
import Either.Decode as ED

import Common.Utils as CU exposing ((=>))
import Type.User as TU
import Type.BaseResource as TB



-- MODEL

type alias Session =
  { id : Int
  , session : String
  , user : Either TU.User TB.Base
  , type_ : String
  , link : String
  , updatedAt : DT.DateTime
  , createdAt : DT.DateTime
  }


decode : JD.Decoder Session
decode =
  JD.succeed Session
  |: (JD.field "id" JD.int)
  |: (JD.field "session-id" JD.string)
  |: (JD.field "user" (ED.either TU.decode TB.decode))
  |: (JD.field "type" JD.string)
  |: (JD.field "link" JD.string)
  |: (JD.field "updated-at" CU.decodeTS)
  |: (JD.field "created-at" CU.decodeTS)


encode : Session -> JE.Value
encode s =
  JE.object
    [ "id" => JE.int s.id
    , "session-id" => JE.string s.session
    , "user" =>
      case s.user of
        (Left user ) -> TU.encode user
        (Right base) -> TB.encode base
    , "type" => JE.string s.type_
    , "link" => JE.string s.link
    , "updated-at" => CU.encodeTS s.updatedAt
    , "created-at" => CU.encodeTS s.createdAt
    ]
