.PHONY: build

build:
	elm-make ./src/Main.elm --output=./main.js

run:
	elm-reactor