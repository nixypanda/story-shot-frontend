module Library.Auth exposing
  ( buildAuthHeader
  )

import Http
import Base64


buildAuthHeader : String -> String -> Http.Header
buildAuthHeader username password =
  Http.header "Authorization"
    ("Basic " ++ (buildAuthorizationToken username password))


buildAuthorizationToken : String -> String -> String
buildAuthorizationToken username password =
  Base64.encode (username ++ ":" ++ password)
