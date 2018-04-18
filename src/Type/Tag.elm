module Type.Tag exposing (..)

import Type.Genre as TG
import Time.DateTime as DT
import Json.Decode as JD

import Common.Utils as CU
import Type.Genre as TG


type alias Tag =
  { id : Int
  , name : String
  , genre : TG.Genre
  , type_ : String
  , link : String
  , updatedAt : DT.DateTime
  , createdAt : DT.DateTime
  }


decode : JD.Decoder Tag
decode =
  JD.map7 Tag
    (JD.field "id" JD.int)
    (JD.field "name" JD.string)
    (JD.field "genre" TG.decode)
    (JD.field "type" JD.string)
    (JD.field "link" JD.string)
    (JD.field "updated-at" CU.decodeTS)
    (JD.field "created-at" CU.decodeTS)
