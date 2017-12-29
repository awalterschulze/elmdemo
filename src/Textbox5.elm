import Html exposing (beginnerProgram, div, button, text, Html, span, label, input)
import Html.Events exposing (onClick, onWithOptions, targetValue, Options)
import Html.Attributes exposing (style, value)
import Navigation
import UrlParser exposing (s, parsePath, top, (<?>), (</>), intParam, stringParam, map)
import Json.Decode as Json
import Dict

main = Navigation.program (\_ -> Nop)
    { init = init
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none)
    }

type alias Model = {
    num       : Int
    , letters : Dict.Dict Int String
    , word    : String
    , size    : Int
}

newModel : Int -> String -> Model
newModel num word = Model num (newCharDict word) word (String.length word)

parseModel : Maybe Int -> Maybe String -> Model
parseModel maybeNum maybeStr = 
    let num = Maybe.withDefault 0 maybeNum
        word = Maybe.withDefault "" maybeStr
    in newModel num word

urlSpec : UrlParser.Parser (Maybe.Maybe Int -> Maybe.Maybe String -> a) a
urlSpec = top <?> intParam "num" <?> stringParam "word"

urlpath : UrlParser.Parser (Model -> Model) Model
urlpath = map parseModel urlSpec

init : Navigation.Location -> (Model, Cmd Msg)
init location = 
    let loc = { location | pathname = "" } -- we only want to parse the url parameters and we don't care about the rest of the path.
    in case parsePath urlpath loc of
    (Just model) -> (model, Cmd.none)
    _ -> (newModel 0 "", Cmd.none)

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] (List.map (viewLetter model) (List.range 0 model.num))
    , button [ onClick Increment ] [ text "+" ]
    , viewInput "Word" model.word 
    ]

viewLetter : Model -> Int -> Html Msg
viewLetter model index = span [style [("color", chooseColor (index % 4))]]
  [text (chooseLetter model index)]

chooseColor : Int -> String
chooseColor c = case c of
  0 -> "red"
  1 -> "yellow"
  2 -> "blue"
  3 -> "green"
  _ -> ""

chooseLetter : Model -> Int -> String
chooseLetter model index = if model.size == 0 
    then ""
    else case Dict.get (index % model.size) (model.letters) of
            Nothing -> ""
            (Just letter) -> letter

newCharDict : String -> Dict.Dict Int String
newCharDict word = Dict.fromList <| List.indexedMap (\index char -> (index, String.fromChar char)) <| String.toList word

type Msg = Nop
  | Increment 
  | Decrement
  | EditWord String

seturl : Model -> Cmd Msg
seturl {num, word} = Navigation.modifyUrl <| "?num=" ++ toString num ++ "&word=" ++ word

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Nop -> (model, Cmd.none)

    Increment -> let m = {
        model | num = model.num + 1
    } in (m, seturl m)

    Decrement -> let m = {
        model | num = model.num - 1
    } in (m, seturl m)

    (EditWord w) -> let 
        m = newModel model.num w
    in (m, seturl m)

viewInput : String -> String -> Html Msg
viewInput name v = div [] [
        label [Html.Attributes.for name] [text name]
        , input [
            Html.Attributes.type_ "text"
            , onInput EditWord
            , value v
        ] []
    ]

onInput : (String -> msg) -> Html.Attribute msg
onInput edit =
    onWithOptions "input" preventDefaults (Json.map edit targetValue)

preventDefaults : Options
preventDefaults = Options True True