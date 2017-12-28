import Html exposing (beginnerProgram, div, button, text, Html, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Dict

main =
  beginnerProgram { model = 0, view = view, update = update }

type alias Model = Int

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
charDict = String.toList word |> List.indexedMap (\index char -> (index, String.fromChar char)) |> Dict.fromList

type Msg = Increment 
  | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment -> model + 1

    Decrement -> model - 1
