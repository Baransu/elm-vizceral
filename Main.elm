port module Main exposing (..)

import Html exposing (Html, Attribute, node, text)
import Html.Attributes exposing (property, attribute)
import Html.Events exposing (on, targetValue)
import Json.Decode as Decode
import Json.Encode as Encode


type alias Model =
    { path : List String }


type Msg
    = PushTrafficData
    | UpdatePath (List String)


init : ( Model, Cmd Msg )
init =
    ( { path = [ "us-westsdf-2" ]
      }
      -- initial data push to render hard typed data (hack, to remove)
    , command ()
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PushTrafficData ->
            -- TODO push data in command
            ( model, Cmd.none )

        UpdatePath path ->
            { model | path = path } ! []


view : Model -> Html Msg
view model =
    node "vizceral-component"
        [ property "view" <| Encode.list <| List.map Encode.string model.path
        , attribute "show-labels" "true"
        , recordViewChange
          -- TODO record other things too
        ]
        [ text <| toString model.path ]


recordViewChange : Attribute Msg
recordViewChange =
    on "vizceral-view-changed" <|
        Decode.map UpdatePath
            (Decode.at [ "detail", "view" ] (Decode.list Decode.string))


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- TODO implement proper command for sending data to vizcerl


port command : () -> Cmd msg


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
