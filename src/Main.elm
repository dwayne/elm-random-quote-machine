module Main exposing (main)


import Html as H
import Html.Attributes as HA
import Url.Builder as UB


main : H.Html msg
main =
    let
        quote =
            { text = "You become what you believe."
            , author = "Oprah Winfrey"
            }
    in
    viewCard quote


-- QUOTE


type alias Quote =
    { text : String
    , author : String
    }


viewQuote : Quote -> H.Html msg
viewQuote { text, author } =
    H.blockquote [ HA.class "quote" ]
        [ H.p [ HA.class "quote__text" ] [ H.text text ]
        , H.footer [ HA.class "quote__footer" ]
            [ H.text <| mdash ++ " "
            , H.cite [ HA.class "quote__author" ] [ H.text author ]
            ]
        ]


mdash : String
mdash =
    "\u{2014}"


-- BUTTONS


type alias ButtonOptions =
    { text : String
    , title : String
    }


viewButton : ButtonOptions -> H.Html msg
viewButton { text, title } =
    H.button
        [ HA.class "button"
        , HA.title title
        ]
        [ H.text text ]


type alias IconButtonOptions =
    { icon : Icon
    , quote : Quote
    }


type Icon
    = Twitter
    | Tumblr


viewIconButton : IconButtonOptions -> H.Html msg
viewIconButton { icon, quote } =
    let
        { name, url, class } =
            case icon of
                Twitter ->
                    { name = "Twitter"
                    , url = twitterUrl quote
                    , class = "fa-twitter"
                    }

                Tumblr ->
                    { name = "Tumblr"
                    , url = tumblrUrl quote
                    , class = "fa-tumblr"
                    }
    in
    H.a
        [ HA.class "icon-button"
        , HA.href url
        , HA.target "_blank"
        , HA.title <| "Share on " ++ name
        ]
        [ H.i [ HA.class "fa-brands", HA.class class ] [] ]


twitterUrl : Quote -> String
twitterUrl { text, author } =
  let
    tweet = "\"" ++ text ++ "\" ~ " ++ author
  in
    UB.crossOrigin "https://twitter.com"
      [ "intent", "tweet" ]
      [ UB.string "hashtags" "quotes"
      , UB.string "text" tweet
      ]


tumblrUrl : Quote -> String
tumblrUrl { text, author } =
  UB.crossOrigin "https://www.tumblr.com"
    [ "widgets", "share", "tool" ]
    [ UB.string "posttype" "quote"
    , UB.string "tags" "quotes"
    , UB.string "content" text
    , UB.string "caption" author
    , UB.string "canonicalUrl" "https://www.tumblr.com/docs/en/share_button"
    ]


-- ACTIONS


viewActions : Quote -> H.Html msg
viewActions quote =
    H.ul [ HA.class "actions" ]
        [ H.li []
            [ viewIconButton
                { icon = Twitter
                , quote = quote
                }
            ]
        , H.li []
            [ viewIconButton
                { icon = Tumblr
                , quote = quote
                }
            ]
        , H.li []
            [ viewButton
                { text = "New quote"
                , title = "Select a new random quote to display"
                }
            ]
        ]


-- CARD


viewCard : Quote -> H.Html msg
viewCard quote =
    H.div
        [ HA.class "card" ]
        [ H.div [ HA.class "card__quote" ] [ viewQuote quote ]
        , H.div [ HA.class "card__actions" ] [ viewActions quote ]
        ]
