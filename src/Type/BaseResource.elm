module Type.BaseResource exposing (..)

import Json.Decode as JD
import Json.Encode as JE

import Common.Utils exposing ((=>))


type alias Base =
  { id : Int
  , type_ : String
  , link : String
  }


decode : JD.Decoder Base
decode =
  JD.map3 Base
  (JD.field "id" JD.int)
  (JD.field "type" JD.string)
  (JD.field "link" JD.string)


encode : Base -> JE.Value
encode base =
  JE.object
  [ "id" => JE.int base.id
  , "type" => JE.string base.type_
  , "link" => JE.string base.link
  ]
