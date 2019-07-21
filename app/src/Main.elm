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
