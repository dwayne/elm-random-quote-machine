module Main exposing (main)


import Html exposing (Html, a, blockquote, button, cite, div, footer, i, p, span, text)
import Html.Attributes exposing (class, href, target)


main : Html msg
main =
  div []
    [ div [ class "mb15 quote" ]
        [ blockquote [ class "m0 mb30" ]
            [ p [ class "quote__content-wrapper" ]
                [ span [ class "mr12" ]
                    [ i [ class "fas fa-quote-left" ] [] ]
                , text "I am not a product of my circumstances. I am a product of my decisions."
                ]
            , footer [ class "text-right" ]
                [ text "— "
                , cite [ class "quote__author" ]
                    [ text "Stephen Covey" ]
                ]
            ]
        , div [ class "flex" ]
            [ div [ class "mr10" ]
                [ a [ class "icon-button", href "https://twitter.com/intent/tweet?hashtags=quotes&text=%22I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.%22%20~%20Stephen%20Covey", target "_blank" ]
                    [ i [ class "fab fa-twitter" ] [] ]
                ]
            , div []
                [ a [ class "icon-button", href "https://www.tumblr.com/widgets/share/tool?posttype=quote&tags=quotes&caption=Stephen%20Covey&content=I%20am%20not%20a%20product%20of%20my%20circumstances.%20I%20am%20a%20product%20of%20my%20decisions.&canonicalUrl=https%3A%2F%2Fwww.tumblr.com%2Fdocs%2Fen%2Fshare_button", target "_blank" ]
                    [ i [ class "fab fa-tumblr" ] [] ]
                ]
            , div [ class "push-right" ]
                [ button [ class "button" ] [ text "New quote" ] ]
            ]
        ]
    , footer [ class "attribution" ]
        [ text "by "
        , a [ class "attribution__link", href "https://github.com/dwayne/" ]
            [ text "dwayne" ]
        ]
    ]
