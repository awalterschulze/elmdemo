import Html exposing (beginnerProgram, div, button, text, Html, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Navigation
import UrlParser exposing (s, parsePath, top, (<?>), (</>), intParam)
import Dict

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
    , div [] (List.map viewLetter (List.range 0 model))
    , button [ onClick Increment ] [ text "+" ]
    ]

viewLetter : Int -> Html Msg
viewLetter index = span [style [("color", chooseColor index)]]
  [text (chooseLetter index)]

chooseColor : Int -> String
chooseColor c = case c % 4 of
  0 -> "red"
  1 -> "yellow"
  2 -> "blue"
  3 -> "green"
  _ -> ""

chooseLetter : Int -> String
chooseLetter index = case Dict.get (index % String.length word) charDict of
  Nothing -> ""
  (Just letter) -> letter

word : String
word = "TreeBay"

charDict : Dict.Dict Int String
charDict = Dict.fromList <| List.indexedMap (\index char -> (index, String.fromChar char)) <| String.toList word

type Msg = Nop
  | Increment 
  | Decrement

appendNum : Int -> Cmd Msg
appendNum num = Navigation.modifyUrl <| "?num=" ++ toString num

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Nop -> (model, Cmd.none)

    Increment -> let m = model + 1 in
      (m, appendNum m)

    Decrement -> let m = model - 1 in
      (m, appendNum m)
