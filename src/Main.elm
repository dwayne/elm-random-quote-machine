module Main exposing (main)


import Browser
import Html exposing (Html, a, blockquote, button, cite, div, footer, i, p, span, text)
import Html.Attributes exposing (class, href, style, target)
import Html.Events exposing (onClick)
import Http
import Json.Decode as D
import Random
import Url.Builder exposing (crossOrigin, string)


main : Program Url Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }


-- MODEL


type alias Model =
  { quotes : List Quote
  , quote : Quote
  , color : Color
  }


type alias Quote =
  { content : String
  , author : String
  }


type alias Color = String
type alias Url = String


init : Url -> (Model, Cmd Msg)
init url =
  ( { quotes = []
    , quote = defaultQuote
    , color = defaultColor
    }
  , Cmd.batch
      [ generateNewQuoteAndColor localQuotes
      , getQuotes url
      ]
  )


-- UPDATE


type Msg
  = ClickedNewQuote
  | NewQuoteAndColor (Quote, Color)
  | GotQuotes (Result Http.Error (List Quote))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ClickedNewQuote ->
      ( model
      , generateNewQuoteAndColor model.quotes
      )

    NewQuoteAndColor (quote, color) ->
      ( { model | quote = quote, color = color }
      , Cmd.none
      )

    GotQuotes (Ok remoteQuotes) ->
      ( { model | quotes = remoteQuotes }
      , Cmd.none
      )

    GotQuotes (Err _) ->
      ( { model | quotes = localQuotes }
      , Cmd.none
      )


-- COMMANDS


generateNewQuoteAndColor : List Quote -> Cmd Msg
generateNewQuoteAndColor quotes =
  Random.generate NewQuoteAndColor <|
      Random.pair
        (Random.uniform defaultQuote quotes)
        (Random.uniform defaultColor allColors)


getQuotes : Url -> Cmd Msg
getQuotes url =
  Http.get
    { url = url
    , expect = Http.expectJson GotQuotes quotesDecoder
    }


-- DECODERS


quotesDecoder : D.Decoder (List Quote)
quotesDecoder =
  D.field "quotes" (D.list quoteDecoder)


quoteDecoder : D.Decoder Quote
quoteDecoder =
  D.map2 Quote
    (D.field "content" D.string)
    (D.field "author" D.string)


-- VIEW


view : Model -> Html Msg
view { quote, color } =
  div
    [ class "vh100 middle default-background-color has-background-color-transition"
    , style "background-color" color
    ]
    [ div []
        [ viewQuote quote color
        , viewAttribution
        ]
    ]


viewQuote : Quote -> Color -> Html Msg
viewQuote quote color =
  div
    [ class "mb15 quote has-color-transition"
    , style "color" color
    ]
    [ blockquote [ class "m0 mb30" ]
        [ p [ class "quote__content-wrapper" ]
            [ span [ class "mr12" ] [ i [ class "fas fa-quote-left" ] [] ]
            , text quote.content
            ]
        , footer [ class "text-right" ]
            [ text "— "
            , cite [ class "quote__author" ] [ text quote.author ]
            ]
        ]
    , div [ class "flex" ]
        [ div [ class "mr10" ]
            [ viewIconButton "twitter" (twitterUrl quote) color ]
        , div []
            [ viewIconButton "tumblr" (tumblrUrl quote) color ]
        , div [ class "push-right" ]
            [ button
                [ class "button has-background-color-transition"
                , style "background-color" color
                , onClick ClickedNewQuote
                ]
                [ text "New quote" ]
            ]
        ]
    ]


viewIconButton : String -> String -> Color -> Html msg
viewIconButton name url color =
  a [ class "icon-button has-background-color-transition"
    , style "background-color" color
    , href url
    , target "_blank"
    ]
    [ i [ class ("fab fa-" ++ name) ] [] ]


viewAttribution : Html msg
viewAttribution =
  footer [ class "attribution" ]
      [ text "by "
      , a [ class "attribution__link", href "https://github.com/dwayne/" ]
          [ text "dwayne" ]
      ]


-- HELPERS


twitterUrl : Quote -> String
twitterUrl { content, author } =
  let
    tweet = "\"" ++ content ++ "\" ~ " ++ author
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


-- DATA


defaultQuote : Quote
defaultQuote =
  { content = "I am not a product of my circumstances. I am a product of my decisions."
  , author = "Stephen Covey"
  }


localQuotes : List Quote
localQuotes =
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


defaultColor : String
defaultColor =
  "#333"


allColors : List String
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
