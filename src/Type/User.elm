module Type.User exposing (
  User
  , decode
  , encode
  )

import Either exposing (..)

import Time.DateTime as DT
import Json.Encode as JE
import Json.Decode as JD
import Json.Decode.Extra exposing ((|:))
import Either as E
import Either.Decode as ED

import Common.Utils as CU exposing ((=>))
import Type.Author as TA
import Type.BaseResource as TB



-- MODEL

type alias User =
  { id : Int
  , username : String
  , name : String
  , author : E.Either TA.Author TB.Base
  , type_ : String
  , link : String
  , updatedAt : DT.DateTime
  , createdAt : DT.DateTime
  }


decode : JD.Decoder User
decode =
  JD.succeed User
    |: (JD.field "id" JD.int)
    |: (JD.field "username" JD.string)
    |: (JD.field "display-name" JD.string)
    |: (JD.field "author" (ED.either TA.decode TB.decode))
    |: (JD.field "type" JD.string)
    |: (JD.field "link" JD.string)
    |: (JD.field "updated-at" CU.decodeTS)
    |: (JD.field "created-at" CU.decodeTS)


encode : User -> JE.Value
encode user =
  JE.object
  [ "id" => JE.int user.id
  , "username" => JE.string user.username
  , "display-name" => JE.string user.name
  , "author" =>
    case user.author of
      (Left author) -> TA.encode author
      (Right base) -> TB.encode base
  , "type" => JE.string user.type_
  , "link" => JE.string user.link
  , "updated-at" => CU.encodeTS user.updatedAt
  , "created-at" => CU.encodeTS user.createdAt
  ]
