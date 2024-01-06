module Main exposing (main)


import Html as H
import Html.Attributes as HA


main : H.Html msg
main =
    viewQuote
        { text = "You become what you believe."
        , author = "Oprah Winfrey"
        }


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
