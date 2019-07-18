# Step 3

## Goal

To start using Elm.

After completing this step the app should look exactly as it did after step 2:

![Screenshot of the app after step 3 is completed](assets/step-03-final.png)

## Plan

1. Write the Elm app.
2. Compile it.
3. Load it.

## Write the Elm app

Go to the directory that contains your `index.html` and run `elm init`.

```sh
$ cd path/to/random-quote-machine
$ elm init
```

Press ENTER at the prompt to have an `elm.json` file and an empty `src`
directory created for you.

The `elm.json` file tracks development dependencies, test dependencies and other
relevant metadata for the app.

The `src` directory is where you would place the various modules that comprise
the app.

*Read https://elm-lang.org/0.19.0/init to learn more about `elm init`.*

Create a `Main` module in which to write the HTML.

```sh
$ touch src/Main.elm
```

Edit it to contain the following:

```elm
module Main exposing (main)


import Html exposing (Html, a, blockquote, button, cite, div, footer, i, p, span, text)
import Html.Attributes exposing (autofocus, class, href, target, type_)


main : Html msg
main =
  div [ class "background" ]
    [ div []
        [ div [ class "quote-box" ]
            [ blockquote [ class "quote-box__blockquote"]
                [ p [ class "quote-box__quote-wrapper" ]
                    [ span [ class "quote-left" ]
                        [ i [ class "fa fa-quote-left" ] [] ]
                    , text "I am not a product of my circumstances. I am a product of my decisions."
                    ]
                , footer [ class "quote-box__author-wrapper" ]
                    [ text "\u{2014} "
                    , cite [ class "author" ] [ text "Stephen Covey" ]
                    ]
                ]
            , div [ class "quote-box__actions" ]
                [ div []
                    [ a [ href "https://twitter.com/intent/tweet?hashtags=quotes&text=%22I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.%22%20~%20Stephen%20Covey"
                        , target "_blank"
                        , class "icon-button"
                        ]
                        [ i [ class "fa fa-twitter" ] [] ]
                    ]
                , div []
                    [ a [ href "https://www.tumblr.com/widgets/share/tool?posttype=quote&tags=quotes&content=I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.&caption=Stephen%20Covey&canonicalUrl=https%3A%2F%2Fwww.tumblr.com%2Fdocs%2Fen%2Fshare_button"
                        , target "_blank"
                        , class "icon-button"
                        ]
                        [ i [ class "fa fa-tumblr" ] [] ]
                    ]
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
```

The `module Main exposing (main)` line means that the module's name is `Main`
and the `main` function is part of the its public API.

The import lines make various functions from the `Html` and `Html.Attributes`
modules available for use in the current module. `Html` and `Html.Attributes`
are modules that exist in the `elm/html` package. The `elm/html` package is a
direct dependency of the app which you can find out by looking in the `elm.json`
file.

The `main` function contains mostly what you'd find in the `index.html` file
except that instead of HTML tags and attributes you have function calls.

In general, `<foo attr1="a" attr2="b">bar</foo>` gets translated into the
function call:

```elm
foo [ attr1 "a", attr2 "b" ] [ text "bar" ]
```

Notice that the [em dash](https://www.thepunctuationguide.com/em-dash.html),
`&#8212;`, has to be replaced with its Unicode code point, `\u{2014}`, instead.

Try using `&#8212` in place of the Unicode code point to see what happens.

Try messing with the Unicode code point syntax to see the various error messages
that the Elm compiler would generate.

*You can find Unciode code points for your HTML entities
[here](https://ascii.cl/htmlcodes.htm).*

## Compile it

```sh
elm make src/Main.elm --output=assets/app.js
```

The `Main` module is compiled to JavaScript and saved in the `app.js` file in
the `assets` directory.

## Load it

Edit `index.html` and replace the `body` with the following:

```html
<body>
  <div id="app"></div>
  <script src="assets/app.js"></script>
  <script>
    Elm.Main.init({
      node: document.getElementById("app")
    });
  </script>
</body>
```

The app would be mounted at the `div` with the `app` HTML ID.

View the `index.html` in a browser to observe that absolutely nothing has
changed.
