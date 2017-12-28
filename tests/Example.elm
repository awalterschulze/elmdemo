module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Dict
import Array

suite : Test
suite =
    describe "choose letter" [
        test "letter" <| \_ -> Expect.equal (chooseLetter (newModel "TreeBay") 5) "a"
        , test "wrap" <| \_ -> Expect.equal (chooseLetter (newModel "TreeBay") 11) "B"
        , test "empty" <| \_ -> Expect.equal (chooseLetter (newModel "") 3) ""
        , fuzz string "fuzz 5" <| \randomlyGeneratedString -> Expect.equal (testChooseLetter randomlyGeneratedString 5) (chooseLetter (newModel randomlyGeneratedString) 5)
        , fuzz2 string int "fuzzy" <| \randomlyGeneratedString index -> Expect.equal (testChooseLetter randomlyGeneratedString index) (chooseLetter (newModel randomlyGeneratedString) index)
    ]

type alias Model = {
    letters : Dict.Dict Int String
    , word    : String
    , size    : Int
}

newCharDict : String -> Dict.Dict Int String
newCharDict word = Dict.fromList <| List.indexedMap (\index char -> (index, String.fromChar char)) <| String.toList word

newModel : String -> Model
newModel word = Model (newCharDict word) word (String.length word)

chooseLetter : Model -> Int -> String
chooseLetter model index = if model.size == 0 
    then ""
    else case Dict.get (index % model.size) (model.letters) of
            Nothing -> ""
            (Just letter) -> letter

testChooseLetter : String -> Int -> String
testChooseLetter word index = if String.length word == 0 then ""
     else let chars = Array.fromList <| String.toList word
          in case Array.get (index % String.length word) chars of
                Nothing -> ""
                (Just j) -> String.fromChar j