port module Main exposing (..)

import Html exposing (Html, node)
import Html.Attributes exposing (property)
import Json.Encode exposing (..)


type alias Model =
    Int


type Msg
    = Increment Int


init : ( Model, Cmd Msg )
init =
    ( 0, command () )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment _ ->
            ( model + 1, command () )


port command : () -> Cmd msg


port onCommand : (Int -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onCommand Increment
        ]


view : Model -> Html Msg
view model =
    node "vizceral-component" [ property "view" <| list [ string "us-east-1" ] ] []


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
