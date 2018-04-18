module Type.Genre exposing (
    Genre(..)
  , decode
  )


import Json.Decode as JD


{-
Is it a work of fiction or the events actully took place
-}
type Genre =
  Fiction
  | NonFiction


decode : JD.Decoder Genre
decode =
  let
      f genre = case genre of
        "Fiction" -> JD.succeed Fiction
        "NonFiction" -> JD.succeed NonFiction
        _ -> JD.fail "Genre value can only be [Fiction, NonFiction]"
  in
    JD.string |> JD.andThen f
