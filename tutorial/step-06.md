# Step 6

## Goal

To get quotes from a remote source on page load.

When the app opens for the first time it should attempt to get quotes from an
external URL. The quotes are returned in the JSON format in the following form:

```json
{
  "quotes": [
    { "content": "Life isn't about getting and having, it's about giving and being.", "author": "Kevin Kruse" },
    { "content": "Whatever the mind of man can conceive and believe, it can achieve.", "author": "Napoleon Hill" },
    ...
  ]
}
```

## Plan

1. Write JSON decoders to decode the quotes.
2. Get the quotes.
3. Pass the external URL from which to get the quotes via a flag.
4. Select a random quote when the app loads.

## Write JSON decoders to decode the quotes

Install [elm/json](https://package.elm-lang.org/packages/elm/json/1.1.3/).

```sh
$ elm install elm/json
```

Write the decoders.

```elm
import Json.Decode as D


-- DECODERS


quotesDecoder : D.Decoder (List Quote)
quotesDecoder =
  D.field "quotes" (D.list quoteDecoder)


quoteDecoder : D.Decoder Quote
quoteDecoder =
  D.map2 Quote
    (D.field "content" D.string)
    (D.field "author" D.string)
```

The `quoteDecoder` can decode JSON in the format:

```json
{ "content": "...", "author": "..." }
```

And, the `quotesDecoder` can decode JSON in the format:

```json
{
  "quotes": [
    { "content": "...", "author": "..." },
    ...
  ]
}
```

Read the [intro to JSON decoders](https://guide.elm-lang.org/effects/json.html).

## Get the quotes

Install [elm/http](https://package.elm-lang.org/packages/elm/http/2.0.0/).

```sh
$ elm install elm/http
```

Get the quotes when the app loads.

```elm
import Http


init : () -> (Model, Cmd Msg)
init _ =
  ( -- ...
  , getQuotes "https://gist.githubusercontent.com/dwayne/ff832ab1d4a0bf81585870369f984ebc/raw/46d874a29e9efe38006ec9865ad67b054ef312a8/quotes.json"
  )


type Msg
  = -- ...
  | GotQuotes (Result Http.Error (List Quote))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    -- ...

    GotQuotes (Ok remoteQuotes) ->
      ( { model | quotes = remoteQuotes }
      , Cmd.none
      )

    GotQuotes (Err _) ->
      ( model, Cmd.none )


-- COMMANDS


getQuotes : String -> Cmd Msg
getQuotes url =
  Http.get
    { url = url
    , expect = Http.expectJson GotQuotes quotesDecoder
    }
```

Read the [intro to HTTP](https://guide.elm-lang.org/effects/http.html).

## Pass the external URL from which to get the quotes via a flag

To make the external URL easily configurable pass it into the app via a
[flag](https://guide.elm-lang.org/interop/flags.html).

Edit `index.html`.

```js
Elm.Main.init({
  node: document.getElementById("app"),
  flags: "https://gist.githubusercontent.com/dwayne/ff832ab1d4a0bf81585870369f984ebc/raw/46d874a29e9efe38006ec9865ad67b054ef312a8/quotes.json"
});
```

Edit `src/Main.elm`.

```elm
main : Program String Model Msg
main =
  -- ...


init : String -> (Model, Cmd Msg)
init url =
  ( -- ...
  , getQuotes url
  )
```

## Select a random quote when the app loads

```elm
init : String -> (Model, Cmd Msg)
init url =
  ( -- ...
  , Cmd.batch
      [ generateNewQuoteAndColor allQuotes
      , getQuotes url
      ]
  )


update msg model =
  case msg of
    ClickedNewQuote ->
      ( model
      , generateNewQuoteAndColor model.quotes
      )

    -- ...


generateNewQuoteAndColor : List Quote -> Cmd Msg
generateNewQuoteAndColor quotes =
  Random.generate NewQuoteAndColor <|
    Random.pair
      (Random.uniform defaultQuote quotes)
      (Random.uniform defaultColor allColors)
```
