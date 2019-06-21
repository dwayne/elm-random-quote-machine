module Main exposing (main)


import Html exposing (Html, a, blockquote, button, cite, div, footer, i, p, span, text)
import Html.Attributes exposing (class, href, target)
import Url.Builder exposing (crossOrigin, string)


type alias Quote =
  { content : String
  , author : String
  }


main : Html msg
main =
  let
    quote =
      { content = "I am not a product of my circumstances. I am a product of my decisions."
      , author = "Stephen Covey"
      }
  in
    view quote


-- VIEW


view : Quote -> Html msg
view quote =
  div []
    [ viewQuote quote
    , viewAttribution
    ]


viewQuote : Quote -> Html msg
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
              [ button [ class "button" ] [ text "New quote" ] ]
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
