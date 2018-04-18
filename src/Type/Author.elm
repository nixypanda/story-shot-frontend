module Type.Author exposing (..)


import Json.Encode as JE
import Json.Decode as JD
import Time.DateTime as DT

import Common.Utils as CU exposing ((=>))


type alias Author =
  { id : Int
  , name : String
  , type_ : String
  , link : String
  , updatedAt : DT.DateTime
  , createdAt : DT.DateTime
  }


decode : JD.Decoder Author
decode =
  JD.map6 Author
    (JD.field "id" JD.int)
    (JD.field "name" JD.string)
    (JD.field "type" JD.string)
    (JD.field "link" JD.string)
    (JD.field "updated-at" CU.decodeTS)
    (JD.field "created-at" CU.decodeTS)


encode : Author -> JE.Value
encode author =
  JE.object
  [ "id" => JE.int author.id
  , "name" => JE.string author.name
  , "type" => JE.string author.type_
  , "link" => JE.string author.link
  , "updated-at" => CU.encodeTS author.updatedAt
  , "created-at" => CU.encodeTS author.createdAt
  ]
