module Common.Utils exposing (..)


import Time.DateTime as DT
import Json.Decode as JD
import Json.Encode as JE
import Http


{- |
   This utility function takes in an error and returns a string specifying what the error
   was. (which will be used further to display a meaningful message for that type of error
   atleast I find them helpful.
 -}
errorMapper : Http.Error -> String
errorMapper error =
  case error of
    Http.BadUrl str ->
      "You did not provide a valid URL: " ++ str

    Http.Timeout ->
      "Backend is sleepy not wakey"

    Http.NetworkError ->
      "My search algorithm tanked!"

    Http.BadStatus _ ->
      "There was a failure "

    Http.BadPayload str _ ->
      "You've got messed up data: " ++ str


decodeTS : JD.Decoder DT.DateTime
decodeTS =
  let
    f datestring =
      case DT.fromISO8601 datestring of
        Err err -> JD.fail err
        Ok dt -> JD.succeed dt
  in
    JD.string |> JD.andThen f


encodeTS : DT.DateTime -> JE.Value
encodeTS = DT.toISO8601 >> JE.string


(=>) : a -> b -> ( a, b )
(=>) =
  (,)



{-|
  infixl 0 means the (=>) operator has the same precedence as (<|) and (|>),
  meaning you can use it at the end of a pipeline and have the precedence work out.
 -}
infixl 0 =>
