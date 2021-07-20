module Main exposing (..)

import Browser
import Html exposing (Html, text, pre)
import Http
import List exposing (map)
import Dict exposing (Dict)
import Csv
import Csv.Decode
import Date exposing (Interval(..), range, fromCalendarDate)
import Time exposing (Month(..))



-- MAIN
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

-- MODEL
type Model
  = Failure Http.Error
  | Loading
  | Success String


init : () -> (Model, Cmd Msg)
init _ =
  let 
    urls = [
      "https://nextcloud.weder.me/s/q6TJbBGbRnEiwqX/download"
      ]

    url2commands =     
        map (\x -> Http.get{
        url = x,
        expect = Http.expectString GotText
        })
  in
  ( Loading
  , Cmd.batch <| url2commands urls
  )


-- UPDATE
type Msg
  = GotText (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotText result ->
      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)

        Err errorString ->
          (Failure errorString, Cmd.none)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW
view : Model -> Html Msg
view model =

  case model of
    Failure errorString ->
      text <| Debug.toString errorString

    Loading ->
      text "Loading..."

    Success fullText ->
        text <| Debug.toString fullText
