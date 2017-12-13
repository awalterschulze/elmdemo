import Html exposing (beginnerProgram, div, button, text, Html)
import Html.Events exposing (onClick)
import Navigation
import UrlParser exposing (s, parsePath, top, (<?>), (</>), intParam)

main = Navigation.program (\_ -> Nop)
    { init = init
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none)
    }

type alias Model = Int

init : Navigation.Location -> (Model, Cmd Msg)
init location = let l = { location | pathname = "" }
    in case parsePath (top <?> intParam "num") l of
    (Just (Just n)) -> (n, Cmd.none)
    _ -> (0, Cmd.none)

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [text <| String.concat <| List.map (\_ -> "*") (List.range 0 model)]
    , button [ onClick Increment ] [ text "+" ]
    ]


type Msg = Nop
  | Increment 
  | Decrement

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Nop -> (model, Cmd.none)

    Increment -> let m = model + 1 in
      (m, Navigation.modifyUrl <| "?num=" ++ toString m)

    Decrement -> let m = model - 1 in
      (m, Navigation.modifyUrl <| "?num=" ++ toString m)
