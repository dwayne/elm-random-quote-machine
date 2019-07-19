# Step 4

## Goal

To refactor the Elm code.

After completing this step the app should look exactly as it did after step 2:

![Screenshot of the app after step 3 is completed](assets/step-04-final.png)

## Plan

1. Extract a `viewQuote` function.
2. Extract a `viewIconButton` function.
3. Extract functions to generate the Twitter and Tumblr URLs.
4. Extract a `viewQuoteBox` function.
5. Add a `Quote` record.

## Extract a `viewQuote` function

In `main`, take the "HTML" that comprises the `blockquote` and name it
`viewQuote`. Add two arguments—one to pass in the content of the quotation and
the other for its author.

```elm
viewQuote : String -> String -> Html msg
viewQuote content author =
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
```

Then, in the place of the `blockquote` call the function:

```elm
viewQuote
  "I am not a product of my circumstances. I am a product of my decisions."
  "Stephen Covey"
```

## Extract a `viewIconButton` function

Notice that

```elm
a [ href "https://twitter.com/intent/tweet?hashtags=quotes&text=%22I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.%22%20%E2%80%94%20Stephen%20Covey"
  , target "_blank"
  , class "icon-button"
  ]
  [ i [ class "fa fa-twitter" ] [] ]
```

and this

```elm
a [ href "https://www.tumblr.com/widgets/share/tool?posttype=quote&tags=quotes&content=I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.&caption=Stephen%20Covey&canonicalUrl=https%3A%2F%2Fwww.tumblr.com%2Fdocs%2Fen%2Fshare_button"
  , target "_blank"
  , class "icon-button"
  ]
  [ i [ class "fa fa-tumblr" ] [] ]
```

are quite similar.

Write a function named `viewIconButton` that captures their similarities and
allows you to pass in their differences as arguments.

```elm
viewIconButton : String -> String -> Html msg
viewIconButton name url =
  a [ href url
    , target "_blank"
    , class "icon-button"
    ]
    [ i [ class ("fa fa-" ++ name) ] [] ]
```

Go back to `main` and replace the links with the appropriate function calls.

For Twitter use:

```elm
viewIconButton "twitter" "https://twitter.com/intent/tweet?hashtags=quotes&text=%22I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.%22%20%E2%80%94%20Stephen%20Covey"
```

For Tumblr use:

```elm
viewIconButton "tumblr" "https://www.tumblr.com/widgets/share/tool?posttype=quote&tags=quotes&content=I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.&caption=Stephen%20Covey&canonicalUrl=https%3A%2F%2Fwww.tumblr.com%2Fdocs%2Fen%2Fshare_button"
```

The Twitter and Tumblr URLs would change based on the quotation's content and
author. It follows that you would need a way to generate the URLs given that
information.

## Extract functions to generate the Twitter and Tumblr URLs

Install
[elm/url](https://package.elm-lang.org/packages/elm/url/1.0.0/)
because it provides the functions you need to build the URLs.

```sh
$ elm install elm/url
```

From the
[Url.Builder](https://package.elm-lang.org/packages/elm/url/1.0.0/Url-Builder)
module import
[crossOrigin](https://package.elm-lang.org/packages/elm/url/1.0.0/Url-Builder#crossOrigin)
and
[string](https://package.elm-lang.org/packages/elm/url/1.0.0/Url-Builder#string).

**N.B.** *The
[string](https://package.elm-lang.org/packages/elm/url/1.0.0/Url-Builder#string)
function ensures that the query parameter is
[percent-encoded](https://tools.ietf.org/html/rfc3986#section-2.1).*

```elm
import Url.Builder exposing (crossOrigin, string)
```

To generate the Twitter URL write the `twitterUrl` function:

```elm
twitterUrl : String -> String -> String
twitterUrl content author =
  let
    tweet = "\"" ++ content ++ "\" \u{2014} " ++ author
  in
    crossOrigin "https://twitter.com"
      [ "intent", "tweet" ]
      [ string "hashtags" "quotes"
      , string "text" tweet
      ]
```

And to generate the Tumblr URL write the `tumblrUrl` function:

```elm
tumblrUrl : String -> String -> String
tumblrUrl content author =
  crossOrigin "https://www.tumblr.com"
    [ "widgets", "share", "tool" ]
    [ string "posttype" "quote"
    , string "tags" "quotes"
    , string "content" content
    , string "caption" author
    , string "canonicalUrl" "https://www.tumblr.com/docs/en/share_button"
    ]
```

Update the arguments to the `viewIconButton` function calls.

For Twitter use:

```elm
viewIconButton "twitter" (twitterUrl "I am not a product of my circumstances. I am a product of my decisions." "Stephen Covey")
```

For Tumblr use:

```elm
viewIconButton "tumblr" (tumblrUrl "I am not a product of my circumstances. I am a product of my decisions." "Stephen Covey")
```

## Extract a `viewQuoteBox` function

```elm
viewQuoteBox : String -> String -> Html msg
viewQuoteBox content author =
  div [ class "quote-box" ]
    [ viewQuote content author
    , div [ class "quote-box__actions" ]
        [ div []
            [ viewIconButton "twitter" (twitterUrl content author) ]
        , div []
            [ viewIconButton "tumblr" (tumblrUrl content author) ]
        , -- ...
        ]
    ]
```

Use it in `main`.

```elm
main : Html msg
main =
  div [ class "background" ]
    [ div []
        [ viewQuoteBox
            "I am not a product of my circumstances. I am a product of my decisions."
            "Stephen Covey"
        , -- ...
        ]
    ]
```

## Add a `Quote` record

```elm
type alias Quote =
  { content : String
  , author : String
  }


defaultQuote : Quote
defaultQuote =
  { content = "I am not a product of my circumstances. I am a product of my decisions."
  , author = "Stephen Covey"
  }
```

Update `main`, `viewQuoteBox`, `viewQuote`, `twitterUrl` and `tumblrUrl` to all
work with the `Quote` record.

```elm
main =
  div [ class "background" ]
    [ div []
        [ viewQuoteBox defaultQuote
        , -- ...
        ]
    ]

viewQuoteBox : Quote -> Html msg
viewQuoteBox quote =
  div [ class "quote-box" ]
    [ viewQuote quote
    , div [ class "quote-box__actions" ]
        [ div []
            [ viewIconButton "twitter" (twitterUrl quote) ]
        , div []
            [ viewIconButton "tumblr" (tumblrUrl quote) ]
        , div []
            [ button
                [ type_ "button"
                , autofocus True
                , class "button"
                ]
                [ text "New quote" ]
            ]
        ]
    ]


viewQuote : Quote -> Html msg
viewQuote { content, author } =
  -- ...


twitterUrl : Quote -> Html msg
twitterUrl { content, author } =
  -- ...


tumblrUrl : Quote -> Html msg
tumblrUrl { content, author } =
  -- ...
```

Here's the final version of the code after refactoring:

```elm
module Main exposing (main)


import Html exposing (Html, a, blockquote, button, cite, div, footer, i, p, span, text)
import Html.Attributes exposing (autofocus, class, href, target, type_)
import Url.Builder exposing (crossOrigin, string)


type alias Quote =
  { content : String
  , author : String
  }


defaultQuote : Quote
defaultQuote =
  { content = "I am not a product of my circumstances. I am a product of my decisions."
  , author = "Stephen Covey"
  }


main : Html msg
main =
  div [ class "background" ]
    [ div []
        [ viewQuoteBox defaultQuote
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


viewQuoteBox : Quote -> Html msg
viewQuoteBox quote =
  div [ class "quote-box" ]
    [ viewQuote quote
    , div [ class "quote-box__actions" ]
        [ div []
            [ viewIconButton "twitter" (twitterUrl quote) ]
        , div []
            [ viewIconButton "tumblr" (tumblrUrl quote) ]
        , div []
            [ button
                [ type_ "button"
                , autofocus True
                , class "button"
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


viewIconButton : String -> String -> Html msg
viewIconButton name url =
  a [ href url
    , target "_blank"
    , class "icon-button"
    ]
    [ i [ class ("fa fa-" ++ name) ] [] ]
```
