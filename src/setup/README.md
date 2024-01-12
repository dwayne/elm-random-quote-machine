# Project Setup

I wanted to go through a few administrative things before I started executing on the process as describe [here](/plan.md#process).

When I'm building a project I usually set things up as I need them. This way I don't end up with any superfluous artifacts. However, for the purposes of this guide I will show you the setup for the supporting code in advance so that we don't have to cover any of this stuff in the main part of the guide.

The setup is also atypical for Elm projects so it may be worthwhile for you to see an alternative way of doing things.

## The project directory

I will be doing all my work in a directory called `elm-random-quote-machine`.

```bash
mkdir -p /path/to/elm/projects/elm-random-quote-machine
```

## The directory structure

At the end of this guide the directory structure would be as shown below.

```txt
/path/to/elm/projects/elm-random-quote-machine/
├─ .build/
│  ├─ elm-random-quote-machine/
│  │  ├─ app.js
│  │  ├─ index.css
│  │  ├─ index.html
│  ├─ prototype/
│  │  ├─ actions.html
│  │  ├─ app.html
│  │  ├─ attribution.html
│  │  ├─ buttons.html
│  │  ├─ card.html
│  │  ├─ index.css
│  │  ├─ index.css.map
│  │  ├─ quote.html
├─ bin/
│  ├─ build
│  ├─ build-production
│  ├─ build-prototype
│  ├─ check
│  ├─ check-scripts
│  ├─ clean
│  ├─ deploy
│  ├─ format
│  ├─ review
│  ├─ serve
│  ├─ serve-prototype
├─ html/
│  ├─ index.html
├─ prototype/
│  ├─ actions.html
│  ├─ app.html
│  ├─ attribution.html
│  ├─ buttons.html
│  ├─ card.html
│  ├─ quote.html
│  ├─ sass
├─ review/
│  ├─ src/
│  │  ├─ ReviewConfig.elm
│  ├─ elm.json
├─ sass/
│  ├─ _actions.scss
│  ├─ _app.scss
│  ├─ _attribution.scss
│  ├─ _base.scss
│  ├─ _buttons.scss
│  ├─ _card.scss
│  ├─ _colors.scss
│  ├─ _fonts.scss
│  ├─ _quote.scss
│  ├─ _transitions.scss
│  ├─ index.scss
├─ src/
│  ├─ API.elm
│  ├─ Main.elm
│  ├─ NonEmptyList.elm
│  ├─ Quote.elm
├─ .gitignore
├─ elm.json
├─ flake.lock
├─ flake.nix
```

## Miscellaneous

### `.build/`

I use the `.build/` directory to store my build outputs.

### `.gitignore`

```
.build/
elm-stuff/
```
