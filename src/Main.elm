module Main exposing (main)


import Browser
import Html exposing (Html, a, blockquote, button, cite, div, footer, i, p, span, text)
import Html.Attributes exposing (class, href, target)
import Html.Events exposing (onClick)
import Http
import Json.Decode as D
import Random
import Url.Builder exposing (crossOrigin, string)


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL


type alias Model =
  { quotes : List Quote
  , currentQuote : Quote
  }


type alias Quote =
  { content : String
  , author : String
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model [] defaultQuote
  , getQuotes
  )


-- UPDATE


type Msg
  = ClickedNewQuote
  | NewQuote Quote
  | GotQuotes (Result Http.Error (List Quote))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ClickedNewQuote ->
      ( model
      , Random.generate NewQuote (Random.uniform defaultQuote model.quotes)
      )

    NewQuote quote ->
      ( { model | currentQuote = quote }
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


getQuotes : Cmd Msg
getQuotes =
  Http.get
    { url = "https://gist.githubusercontent.com/dwayne/ff832ab1d4a0bf81585870369f984ebc/raw/46d874a29e9efe38006ec9865ad67b054ef312a8/quotes.json"
      -- ^ TODO: Pass the URL via a flag.
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


-- SUBSCRIPTIONS


subscriptions : Model -> Sub msg
subscriptions _ =
  Sub.none


-- VIEW


view : Model -> Html Msg
view { currentQuote } =
  div []
    [ viewQuote currentQuote
    , viewAttribution
    ]


viewQuote : Quote -> Html Msg
viewQuote quote =
  div [ class "mb15 quote" ]
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
              [ viewIconButton "twitter" (twitterUrl quote) ]
          , div []
              [ viewIconButton "tumblr" (tumblrUrl quote) ]
          , div [ class "push-right" ]
              [ button [ class "button", onClick ClickedNewQuote ]
                  [ text "New quote" ]
              ]
          ]
      ]


viewIconButton : String -> String -> Html msg
viewIconButton name url =
  a [ class "icon-button", href url, target "_blank" ]
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
