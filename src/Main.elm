module Main exposing (main)

import API
import Browser
import Html as H
import Html.Attributes as HA
import Http
import NonEmptyList exposing (NonEmptyList)
import Quote exposing (Quote)
import Url.Builder as UB


main : Program String Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }



-- MODEL


type alias Model =
    { quotes : NonEmptyList Quote
    }


init : String -> ( Model, Cmd Msg )
init url =
    ( { quotes = defaultQuotes
      }
    , API.getQuotes GotQuotes url
    )


defaultQuotes : NonEmptyList Quote
defaultQuotes =
    NonEmptyList.fromList
        { text = "I am not a product of my circumstances. I am a product of my decisions."
        , author = "Stephen Covey"
        }
        [ { text = "Transferring your passion to your job is far easier than finding a job that happens to match your passion."
          , author = "Seth Godin"
          }
        , { text = "Less mental clutter means more mental resources available for deep thinking."
          , author = "Cal Newport"
          }
        , { text = "How much time he saves who does not look to see what his neighbor says or does or thinks."
          , author = "Marcus Aurelius"
          }
        , { text = "You do not rise to the level of your goals. You fall to the level of your systems."
          , author = "James Clear"
          }
        ]



-- UPDATE


type Msg
    = GotQuotes (Result Http.Error (List Quote))


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        GotQuotes (Ok quotes) ->
            case quotes of
                quote :: restQuotes ->
                    ( { model | quotes = NonEmptyList.fromList quote restQuotes }
                    , Cmd.none
                    )

                [] ->
                    ( model
                    , Cmd.none
                    )

        GotQuotes (Err _) ->
            ( model
            , Cmd.none
            )



-- VIEW


view : Model -> H.Html msg
view { quotes } =
    let
        quote =
            NonEmptyList.head quotes

        attribution =
            { name = "Dwayne Crooks"
            , username = "dwayne"
            , url = "https://github.com/dwayne"
            }
    in
    viewApp quote attribution



-- APP


viewApp : Quote -> Attribution -> H.Html msg
viewApp quote =
    viewLayout << viewContent quote


viewLayout : H.Html msg -> H.Html msg
viewLayout content =
    H.div
        [ HA.class "layout" ]
        [ H.div [ HA.class "layout__content" ] [ content ]
        ]


viewContent : Quote -> Attribution -> H.Html msg
viewContent quote attribution =
    H.div [ HA.class "content" ]
        [ H.main_ [ HA.class "content__card" ] [ viewCard quote ]
        , H.footer
            [ HA.class "content__attribution" ]
            [ viewAttribution attribution ]
        ]



-- CARD


viewCard : Quote -> H.Html msg
viewCard quote =
    H.div
        [ HA.class "card" ]
        [ H.div [ HA.class "card__quote" ] [ viewQuote quote ]
        , H.div [ HA.class "card__actions" ] [ viewActions quote ]
        ]



-- QUOTE


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
    "—"



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
        tweet =
            "\"" ++ text ++ "\" ~ " ++ author
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



-- ATTRIBUTION


type alias Attribution =
    { name : String
    , username : String
    , url : String
    }


viewAttribution : Attribution -> H.Html msg
viewAttribution { name, username, url } =
    H.p
        [ HA.class "attribution" ]
        [ H.text "by "
        , H.a
            [ HA.class "attribution__link"
            , HA.href url
            , HA.target "_blank"
            , HA.title <| "Developed by " ++ name
            ]
            [ H.text username ]
        ]
