module Type.Duration exposing (
  Duration(..)
  , decode
  )


import Json.Decode as JD


{-
How long the story is.
-}
type Duration =
  Short
  | Medium
  | Long
  | ErrorDuration



decode : JD.Decoder Duration
decode =
  let
      f genre = case genre of
        "Short" -> JD.succeed Short
        "Medium" -> JD.succeed Medium
        "Long" -> JD.succeed Long
        _ -> JD.fail "Genre value can only be [Fiction, NonFiction]"
  in
      JD.string |> JD.andThen f
