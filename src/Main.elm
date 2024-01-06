module Main exposing (main)


import Html as H
import Html.Attributes as HA


main : H.Html msg
main =
    H.div []
        [ H.h1 [] [ H.text "Buttons" ]
        , H.h2 [] [ H.text "Button" ]
        , H.p []
            [ viewButton
                { text = "New quote"
                , title = "Select a new random quote to display"
                }
            ]
        , H.h2 [] [ H.text "Icon Button" ]
        , H.p [] [ viewIconButton Twitter ]
        , H.p [] [ viewIconButton Tumblr ]
        ]


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


viewIconButton : Icon -> H.Html msg
viewIconButton icon =
    let
        { name, url, class } =
            case icon of
                Twitter ->
                    { name = "Twitter"
                    , url = "#"
                    , class = "fa-twitter"
                    }

                Tumblr ->
                    { name = "Tumblr"
                    , url = "#"
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
