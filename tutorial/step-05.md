# Step 5

In this step our goal is to make the "New quote" button work. Specifically,
when the "New quote" button is clicked a new quotation will be displayed and
the color of certain elements will change.

When we complete this step our app will look like the following:

![A screenshot of the app after step 5 is completed.](assets/step-05-final.gif)

## Plan

1. [Prepare for randomness](#prepare-for-randomness).
2. [Display a random quote](#display-a-random-quote).
3. [Change colors randomly](#change-colors-randomly).
4. [Add color transitions](#add-color-transitions).

## Prepare for randomness

To work with randomness in our app we'll need to be able to
[command](https://guide.elm-lang.org/effects/) Elm's runtime system to generate
random values for us.

[Browser.element](https://package.elm-lang.org/packages/elm/browser/1.0.1/Browser#element)
allows us to work with [commands](https://guide.elm-lang.org/effects/).

Let's edit `src/Main.elm` to use
[Browser.element](https://package.elm-lang.org/packages/elm/browser/1.0.1/Browser#element).

```elm
module Main exposing (main)


import Browser
-- ...


main : Program () Model msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }


-- MODEL


type alias Model =
  { quote : Quote
  }


type alias Quote =
  -- ...


init : () -> (Model, Cmd msg)
init _ =
  ( { quote = defaultQuote
    }
  , Cmd.none
  )


defaultQuote : Quote
defaultQuote =
  -- ...


-- UPDATE


update : msg -> Model -> (Model, Cmd msg)
update _ model =
  ( model
  , Cmd.none
  )


-- VIEW


view : Model -> Html msg
view { quote } =
  div [ class "background" ]
    [ div []
        [ viewQuoteBox quote
        , -- ...
        ]
    ]


viewQuoteBox : Quote -> Html msg
viewQuoteBox quote =
  -- ...


viewQuote : Quote -> Html msg
viewQuote { content, author } =
  -- ...


twitterUrl : Quote -> String
twitterUrl { content, author } =
  -- ...


tumblrUrl : Quote -> String
tumblrUrl { content, author } =
  -- ...


viewIconButton : String -> String -> Html msg
viewIconButton name url =
  -- ...
```

## Display a random quote

Install [elm/random](https://package.elm-lang.org/packages/elm/random/1.0.0/).

```sh
$ elm install elm/random
```

And then, make the following edits to `src/Main.elm`:

```elm
import Random


main : Program () Model Msg


type alias Model =
   { quote : Quote
   , quotes : List Quote
   }


init : () -> (Model, Cmd msg)
init _ =
  ( { quote = defaultQuote
    , quotes = allQuotes
    }
  , Cmd.none
  )


allQuotes : List Quote
allQuotes =
  [ defaultQuote
  , { content = " Transferring your passion to your job is far easier than finding a job that happens to match your passion."
    , author = "Seth Godin"
    }
  , { content = "Less mental clutter means more mental resources available for deep thinking."
    , author = "Cal Newport"
    }
  , { content = "How much time he saves who does not look to see what his neighbor says or does or thinks."
    , author = "Marcus Aurelius"
    }
  , { content = "You do not rise to the level of your goals. You fall to the level of your systems."
    , author = "James Clear"
    }
  ]


type Msg
  = ClickedNewQuote
  | NewQuote Quote


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ClickedNewQuote ->
      ( model
      , Random.generate NewQuote (Random.uniform defaultQuote model.quotes)
      )

    NewQuote newQuote ->
      ( { model | quote = newQuote }
      , Cmd.none
      )


view : Model -> Html Msg


viewQuoteBox : Quote -> Html Msg
viewQuoteBox quote =
  div [ class "quote-box" ]
    [ -- ...
    , div [ class "quote-box__actions" ]
        [ -- ...
        , -- ...
        , div []
            [ button
                [ -- ...
                , onClick ClickedNewQuote
                ]
                [ text "New quote" ]
            ]
        ]
    ]
```

When the "New quote" button is clicked the `ClickedNewQuote` message is
created by Elm's runtime system and it eventually calls our `update` function
with that message.

The `ClickedNewQuote` branch of our `update` function is selected and it sends
a command to Elm's runtime that tells the runtime to select a random quotation
from our list of quotations and to wrap it in a `NewQuote` message.

When the `NewQuote` message is created by the runtime, the runtime eventually
calls our `update` function with that message. The `NewQuote` branch is
selected and our model gets updated with the new quotation.

## Change colors randomly

Here are the edits you need to make:

```elm
import Html.Attributes exposing (..., style, ...)


type alias Model =
  { -- ...
  , color : Color
  }


type alias Color = String


init : () -> (Model, Cmd msg)
init _ =
  ( { -- ...
    , color = defaultColor
    }
  , Cmd.none
  )


defaultColor : Color
defaultColor =
  "#333"


allColors : List Color
allColors =
  [ "#16a085"
  , "#27ae60"
  , "#2c3e50"
  , "#f39c12"
  , "#e74c3c"
  , "#9b59b6"
  , "#fb6964"
  , "#342224"
  , "#472e32"
  , "#bdbb99"
  , "#77b1a9"
  , "#73a857"
  ]


type Msg
  = ClickedNewQuote
  | NewQuoteAndColor (Quote, Color)


update msg model =
  case msg of
    ClickedNewQuote ->
      ( model
      , Random.generate NewQuoteAndColor <|
          Random.pair
            (Random.uniform defaultQuote model.quotes)
            (Random.uniform defaultColor allColors)
      )

    NewQuoteAndColor (newQuote, newColor) ->
      ( { model | quote = newQuote, color = newColor }
      , Cmd.none
      )


view { quote, color } =
  div
    [ class "background"
    , style "background-color" color
    ]
    [ div []
        [ viewQuoteBox quote color
        , -- ...
        ]
    ]


viewQuoteBox : Quote -> Color -> Html Msg
viewQuoteBox quote color =
  div
    [ class "quote-box"
    , style "color" color
    ]
    [ -- ...
    , div [ class "quote-box__actions" ]
        [ div []
            [ viewIconButton "twitter" (twitterUrl quote) color ]
        , div []
            [ viewIconButton "tumblr" (tumblrUrl quote) color ]
        , div []
            [ button
                [ -- ...
                , style "background-color" color
                , onClick ClickedNewQuote
                ]
                [ text "New quote" ]
            ]
        ]
    ]


viewIconButton : String -> String -> Color -> Html msg
viewIconButton name url color =
  a [ -- ...
    , style "background-color" color
    ]
    [ i [ class ("fa fa-" ++ name) ] [] ]
```

Now, when the "New quote" button is clicked both a quotation and a color are
randomly selected.

```elm
Random.pair
  (Random.uniform defaultQuote model.quotes)
  (Random.uniform defaultColor allColors)
-- : Random.Generator (Quote, Color)
```

## Add color transitions

Finally, let's add some color transitions to make the colors change smoothly.

Add two new classes to `assets/styles.css`:

```css
/* Transitions */

.has-color-transition {
  transition: color 2s;
}

.has-background-color-transition {
  transition: background-color 2s;
}
```

And then, add the `has-color-transition` class to the quote box:

```elm
viewQuoteBox quote color =
  div
    [ class "quote-box has-color-transition"
    , style "color" color
    ]
    [ -- ...
    ]
```

And, add the `has-background-color-transition` class to the background and the
buttons:

```elm
div
  [ class "background has-background-color-transition"
  , style "background-color" color
  ]
  [ -- ...
  ]


button
  [ -- ...
  , class "button has-background-color-transition"
  , style "background-color" color
  , -- ...
  ]
  [ text "New quote" ]


a [ -- ...
  , class "icon-button has-background-color-transition"
  , style "background-color" color
  ]
  [ i [ class ("fa fa-" ++ name) ] [] ]
```

Here's the final version of `src/Main.elm` after we've completed all the changes
in this step:

```elm
module Main exposing (main)


import Browser
import Html exposing (Html, a, blockquote, button, cite, div, footer, i, p, span, text)
import Html.Attributes exposing (autofocus, class, href, style, target, type_)
import Html.Events exposing (onClick)
import Random
import Url.Builder exposing (crossOrigin, string)


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }


-- MODEL


type alias Model =
  { quote : Quote
  , quotes : List Quote
  , color : Color
  }


type alias Quote =
  { content : String
  , author : String
  }


type alias Color = String


init : () -> (Model, Cmd msg)
init _ =
  ( { quote = defaultQuote
    , quotes = allQuotes
    , color = defaultColor
    }
  , Cmd.none
  )


defaultQuote : Quote
defaultQuote =
  { content = "I am not a product of my circumstances. I am a product of my decisions."
  , author = "Stephen Covey"
  }


allQuotes : List Quote
allQuotes =
  [ defaultQuote
  , { content = " Transferring your passion to your job is far easier than finding a job that happens to match your passion."
    , author = "Seth Godin"
    }
  , { content = "Less mental clutter means more mental resources available for deep thinking."
    , author = "Cal Newport"
    }
  , { content = "How much time he saves who does not look to see what his neighbor says or does or thinks."
    , author = "Marcus Aurelius"
    }
  , { content = "You do not rise to the level of your goals. You fall to the level of your systems."
    , author = "James Clear"
    }
  ]


defaultColor : Color
defaultColor =
  "#333"


allColors : List Color
allColors =
  [ "#16a085"
  , "#27ae60"
  , "#2c3e50"
  , "#f39c12"
  , "#e74c3c"
  , "#9b59b6"
  , "#fb6964"
  , "#342224"
  , "#472e32"
  , "#bdbb99"
  , "#77b1a9"
  , "#73a857"
  ]


-- UPDATE


type Msg
  = ClickedNewQuote
  | NewQuoteAndColor (Quote, Color)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ClickedNewQuote ->
      ( model
      , Random.generate NewQuoteAndColor <|
          Random.pair
            (Random.uniform defaultQuote model.quotes)
            (Random.uniform defaultColor allColors)
      )

    NewQuoteAndColor (newQuote, newColor) ->
      ( { model | quote = newQuote, color = newColor }
      , Cmd.none
      )


-- VIEW


view : Model -> Html Msg
view { quote, color } =
  div
    [ class "background has-background-color-transition"
    , style "background-color" color
    ]
    [ div []
        [ viewQuoteBox quote color
        , footer [ class "attribution" ]
            [ text "by "
            , a [ href "https://github.com/dwayne/"
                , target "_blank"
                , class "attribution__link"
                ]
                [ text "dwayne" ]
            ]
        ]
    ]


viewQuoteBox : Quote -> Color -> Html Msg
viewQuoteBox quote color =
  div
    [ class "quote-box has-color-transition"
    , style "color" color
    ]
    [ viewQuote quote
    , div [ class "quote-box__actions" ]
        [ div []
            [ viewIconButton "twitter" (twitterUrl quote) color ]
        , div []
            [ viewIconButton "tumblr" (tumblrUrl quote) color ]
        , div []
            [ button
                [ type_ "button"
                , autofocus True
                , class "button has-background-color-transition"
                , style "background-color" color
                , onClick ClickedNewQuote
                ]
                [ text "New quote" ]
            ]
        ]
    ]


viewQuote : Quote -> Html msg
viewQuote { content, author } =
  blockquote [ class "quote-box__blockquote"]
    [ p [ class "quote-box__quote-wrapper" ]
        [ span [ class "quote-left" ]
            [ i [ class "fa fa-quote-left" ] [] ]
        , text content
        ]
    , footer [ class "quote-box__author-wrapper" ]
        [ text "\u{2014} "
        , cite [ class "author" ] [ text author ]
        ]
    ]


twitterUrl : Quote -> String
twitterUrl { content, author } =
  let
    tweet = "\"" ++ content ++ "\" \u{2014} " ++ author
  in
    crossOrigin "https://twitter.com"
      [ "intent", "tweet" ]
      [ string "hashtags" "quotes"
      , string "text" tweet
      ]


tumblrUrl : Quote -> String
tumblrUrl { content, author } =
  crossOrigin "https://www.tumblr.com"
    [ "widgets", "share", "tool" ]
    [ string "posttype" "quote"
    , string "tags" "quotes"
    , string "content" content
    , string "caption" author
    , string "canonicalUrl" "https://www.tumblr.com/docs/en/share_button"
    ]


viewIconButton : String -> String -> Color -> Html msg
viewIconButton name url color =
  a [ href url
    , target "_blank"
    , class "icon-button has-background-color-transition"
    , style "background-color" color
    ]
    [ i [ class ("fa fa-" ++ name) ] [] ]
```

The end. Go to [step 6](step-06.md).
