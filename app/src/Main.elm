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
