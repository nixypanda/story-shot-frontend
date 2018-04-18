module Route.Login exposing (..)


import Http
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Element.Input as Input
import Json.Decode as JD
import Json.Encode as JE


import Common.Utils exposing ((=>))
import APIBase as AB
import Type.Style as TS
import Type.Session as S
import Type.Error as TE
import Type.Route as Route
import Library.Auth as Auth
import Ports


type alias Field =
  { value : String
  , error : Maybe String
  }

type alias Model =
  { email : Field
  , password : Field
  , serverError : Maybe String
  }


initialModel : Model
initialModel =
  { email = { value = "", error = Nothing }
  , password = { value = "", error = Nothing }
  , serverError = Nothing
  }


view : Model -> Element TS.StyleClass variation Msg
view model =
  let
      renderError me =
        case me of
          Nothing ->
            []

          Just e ->
            [ Input.errorBelow <| el TS.ErrorText [] <| text e
            ]
  in
    column TS.LoginPageStyle [height fill]
      [ row TS.NoStyle [center, width fill, verticalCenter, height fill]
        [ column TS.LoginBoxStyle [width (px 500), padding 50, spacing 25]
          [ Input.username TS.LoginFieldStyle [ padding 15 ]
            { onChange = SetEmail
            , value = model.email.value
            , label =
                Input.placeholder
                  { label = Input.hiddenLabel "username"
                  , text = "username"
                  }
            , options = renderError model.email.error
            }
          , Input.newPassword TS.LoginFieldStyle [ padding 15 ]
            { onChange = SetPassword
            , value = model.password.value
            , label =
                Input.placeholder
                  { label = Input.hiddenLabel "password"
                  , text = "password"
                  }
              , options = renderError model.password.error
            }
          , case model.serverError of
              Nothing -> 
                el TS.NoStyle [] empty

              Just e ->
                el TS.ErrorText [] <| text e

          , button TS.LoginButtonStyle [padding 15, onClick SubmitForm] <| text "Login"
          , row TS.NoStyle [center, spacing 5]
            [ el TS.FadedTextStyle [] <| text "Not yet Rigstered?"
            , Route.href Route.Register <| el TS.LinkStyle [] <| text "Sign up"
            ]
          ]
        ]
      ]


type Msg
  = SubmitForm
  | SetEmail String
  | SetPassword String
  | LoginCompleted (Result Http.Error S.Session)


type ExternalMsg
  = NoOp
  | SetSession (Maybe S.Session)


getSession : String -> String -> Cmd Msg
getSession username password =
  let
    url : String
    url = AB.apiBase ++ "/user/login?include=user"

    request : Http.Request S.Session
    request =
      Http.request
        { method = "GET"
        , headers = [ Auth.buildAuthHeader username password ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson (JD.at ["data"] S.decode)
        , timeout = Nothing
        , withCredentials = False
        }
  in
    Http.send LoginCompleted request


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update msg ({email, password} as model) =
  case msg of
    SubmitForm ->
      case (validateUsername email.value, validatePassWord password.value) of
        (Nothing, Nothing) ->
          { model | serverError = Nothing } => getSession email.value password.value => NoOp

        (errUsername, errPass) ->
          { model
          | email = {email | error = errUsername}
          , password = {password | error = errPass}
          , serverError = Nothing
          }
          => Cmd.none => NoOp

    SetEmail email ->
      { model | email = { value = email, error = validateUsername email }, serverError = Nothing }
      => Cmd.none
      => NoOp

    SetPassword password ->
      { model | password = { value = password, error = validatePassWord password }, serverError = Nothing }
      => Cmd.none
      => NoOp

    LoginCompleted (Err error) ->
      let
        err =
          case error of
            Http.BadStatus response ->
              response.body
                |> JD.decodeString (JD.at ["error"] TE.decode)
                |> Result.map TE.extractMsg
                |> Result.withDefault "Unable to perform login"

            Http.BadPayload err response ->
              "Communication error between devs"

            _ ->
              "Unable to perform login"
      in
      { model | serverError = Just err }
      => Cmd.none
      => NoOp

    LoginCompleted (Ok session) ->
      model
      => Cmd.batch [ storeSession session, Route.modifyUrl Route.Home ]
      => SetSession (Just session)


storeSession : S.Session -> Cmd msg
storeSession = S.encode >> JE.encode 0 >> Just >> Ports.storeSession


validatePassWord : String -> Maybe String
validatePassWord password =
  if password == "" then
    Just "Can't be blank"
  else if String.length password < 3 then
    Just "Password should be greater than 3 characters"
  else
    Nothing


validateUsername : String -> Maybe String
validateUsername username =
  if username == "" then
    Just "Can't be blank"
  else
    Nothing
