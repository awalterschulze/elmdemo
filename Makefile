.PHONY: build

build:
	elm-make ./src/Main.elm --output=./main.js

run:
	elm-reactor

installnavigation:
	elm-package install elm-lang/navigation