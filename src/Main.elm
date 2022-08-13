module Main exposing (main)


import Browser
import Html as H
import Html.Attributes as HA
import Url.Builder as UB


main : Program () Model msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = always Sub.none
    }


-- MODEL


type alias Model =
  { quote : Quote
  }


type alias Quote =
  { text : String
  , author : String
  }


init : () -> (Model, Cmd msg)
init _ =
  ( { quote =
        { text = "Whatever you can do, or dream you can, begin it. Boldness has genius, power and magic in it."
        , author = "Johann Wolfgang von Goethe"
        }
    }
  , Cmd.none
  )


-- UPDATE


update : msg -> Model -> (Model, Cmd msg)
update _ model =
  ( model
  , Cmd.none
  )


-- VIEW


view : Model -> H.Html msg
view { quote } =
  viewCentral <|
    viewColumn
      [ H.main_ []
          [ viewCard
              { top = viewQuote quote
              , bottom =
                  viewActions
                    [ viewButtonLink Twitter quote
                    , viewButtonLink Tumblr quote
                    , viewButton "New quote"
                    ]
              }
          ]
      , H.footer []
          [ viewAttribution ]
      ]


viewCentral : H.Html msg -> H.Html msg
viewCentral body =
  H.div
    [ HA.class "central" ]
    [ H.div
        [ HA.class "central__wrapper" ]
        [ body ]
    ]


viewColumn : List (H.Html msg) -> H.Html msg
viewColumn =
  H.div [ HA.class "column" ]


viewCard : { top : H.Html msg, bottom: H.Html msg } -> H.Html msg
viewCard { top, bottom } =
  H.div
    [ HA.class "card" ]
    [ H.div
        [ HA.class "card__top" ]
        [ top ]
    , H.div
        [ HA.class "card__bottom" ]
        [ bottom ]
    ]


viewQuote : Quote -> H.Html msg
viewQuote { text, author } =
  H.figure
    [ HA.class "quote" ]
    [ H.blockquote
        [ HA.class "quote__content" ]
        [ H.p
            [ HA.class "quote__text" ]
            [ H.span
                [ HA.class "quote__mark" ]
                [ H.i [ HA.class "fas fa-quote-left" ] [] ]
            , H.text text
            ]
        ]
    , H.figcaption
        [ HA.class "quote__attribution" ]
        [ H.text "— "
        , H.cite
            [ HA.class "quote_author" ]
            [ H.text author ]
        ]
    ]


viewActions : List (H.Html msg) -> H.Html msg
viewActions actions =
  let
    viewAction action =
      H.li [ HA.class "actions__action" ] [ action ]
  in
  actions
    |> List.map viewAction
    |> H.ul [ HA.class "actions" ]


type SocialMedia
  = Twitter
  | Tumblr


viewButtonLink : SocialMedia -> Quote -> H.Html msg
viewButtonLink socialMedia quote =
  let
    (name, url) =
      case socialMedia of
        Twitter ->
          ( "twitter"
          , twitterUrl quote
          )

        Tumblr ->
          ( "tumblr"
          , tumblrUrl quote
          )
  in
  H.a
    [ HA.href url
    , HA.target "_blank"
    , HA.class "button"
    ]
    [ H.i [ HA.class <| "fab fa-" ++ name ] [] ]


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


viewButton : String -> H.Html msg
viewButton text =
  H.button
    [ HA.class "button" ]
    [ H.text text ]


viewAttribution : H.Html msg
viewAttribution =
  H.p
    [ HA.class "attribution" ]
    [ H.text "by "
    , H.a
        [ HA.href "https://github.com/dwayne"
        , HA.class "attribution__link"
        ]
        [ H.text "dwayne" ]
    ]
