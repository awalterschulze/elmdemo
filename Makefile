.PHONY: build

build:
	elm-make ./src/Buttons1.elm --output=./buttons1.js
	elm-make ./src/Stars2.elm --output=./stars2.js
	elm-make ./src/Letters3.elm --output=./letters3.js
	elm-make ./src/Navigation4.elm --output=./navigation4.js

run:
	elm-reactor

installnavigation:
	elm-package install elm-lang/navigation