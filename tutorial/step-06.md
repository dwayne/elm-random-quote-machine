# Step 6

In this step our goal is to get quotations from a remote source.

When we complete this step our app will look exactly as it did after
[step 5](step-05.md).

![A screenshot of the app after step 6 is completed](assets/step-05-final.gif)

## Plan

1. [Decode the quotations](#decode-the-quotations).
2. [GET the quotes](#get-the-quotes).
3. [Pass the URL for the remote source via a flag](#pass-the-url-for-the-remote-source-via-a-flag).
4. [Select a random quote when the app initially loads](#select-a-random-quote-when-the-app-initially-loads).

## Decode the quotations

The quotations are returned in the JSON format in the following form:

```json
{
  "quotes": [
    { "content": "Life isn't about getting and having, it's about giving and being.", "author": "Kevin Kruse" },
    { "content": "Whatever the mind of man can conceive and believe, it can achieve.", "author": "Napoleon Hill" }
  ]
}
```

We'll need to install
[elm/json](https://package.elm-lang.org/packages/elm/json/1.1.3/) to decode the
response.

```sh
$ elm install elm/json
```

Let's write the decoders.

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
{
  "content": "...what matters in the long run is sticking with things and working daily to get better at them.",
  "author": "Angela Duckworth"
}
```

And, the `quotesDecoder` can decode JSON in the format:

```json
{
  "quotes": [
    {
      "content": "...what matters in the long run is sticking with things and working daily to get better at them.",
      "author": "Angela Duckworth"
    },
    {
      "content": "Don't judge. Teach. It's a learning process.",
      "author": "Carol S. Dweck"
    }
  ]
}
```

**N.B.** *Read the
[intro to JSON decoders](https://guide.elm-lang.org/effects/json.html) to learn
more.*

## GET the quotes

Install [elm/http](https://package.elm-lang.org/packages/elm/http/2.0.0/).

```sh
$ elm install elm/http
```

And, write the following to fetch the quotes when the app initially loads:

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

**N.B.** *Read the [intro to HTTP](https://guide.elm-lang.org/effects/http.html)
to learn more.*

## Pass the URL for the remote source via a flag

To make the URL easy to configure we'll pass it into the app via a
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

## Select a random quote when the app initially loads

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

The end.
