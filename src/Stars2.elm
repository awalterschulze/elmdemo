import Html exposing (beginnerProgram, div, button, text, Html, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)

main =
  beginnerProgram { model = 0, view = view, update = update }

type alias Model = Int

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] (List.map viewStar (List.range 0 model))
    , button [ onClick Increment ] [ text "+" ]
    ]

viewStar : Int -> Html Msg
viewStar index = span [style [("color", chooseColor index)]]
  [text "*"]

chooseColor : Int -> String
chooseColor c = case c % 4 of
  0 -> "red"
  1 -> "yellow"
  2 -> "blue"
  3 -> "green"
  _ -> ""

type Msg = Increment 
  | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment -> model + 1

    Decrement -> model - 1
