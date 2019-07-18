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
