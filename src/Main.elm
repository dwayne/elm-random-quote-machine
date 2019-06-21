module Main exposing (main)


import Browser
import Html exposing (Html, a, blockquote, button, cite, div, footer, i, p, span, text)
import Html.Attributes exposing (class, href, target)
import Html.Events exposing (onClick)
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


init : () -> (Model, Cmd msg)
init _ =
  let
    quotes =
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
  in
    ( Model quotes defaultQuote
    , Cmd.none
    )


defaultQuote : Quote
defaultQuote =
  { content = "I am not a product of my circumstances. I am a product of my decisions."
  , author = "Stephen Covey"
  }


-- UPDATE


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

    NewQuote quote ->
      ( { model | currentQuote = quote }
      , Cmd.none
      )


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
