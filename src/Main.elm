module Main exposing (main)

import API
import Browser
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import Http
import NonEmptyList exposing (NonEmptyList)
import Quote exposing (Quote)
import Random
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
    , selection : Quote
    }


init : String -> ( Model, Cmd Msg )
init url =
    let
        quotes =
            defaultQuotes
    in
    ( { quotes = quotes
      , selection = NonEmptyList.head quotes
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
    | ClickedNewQuote
    | GotNewSelection Quote


update : Msg -> Model -> ( Model, Cmd Msg )
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

        ClickedNewQuote ->
            ( model
            , generateNewSelection model.quotes
            )

        GotNewSelection selection ->
            ( { model | selection = selection }
            , Cmd.none
            )


generateNewSelection : NonEmptyList Quote -> Cmd Msg
generateNewSelection =
    Random.generate GotNewSelection << NonEmptyList.uniform



-- VIEW


view : Model -> H.Html Msg
view model =
    let
        ( quote, color ) =
            ( model.selection
            , "#3cb371"
            )

        attribution =
            { name = "Dwayne Crooks"
            , username = "dwayne"
            , url = "https://github.com/dwayne"
            }
    in
    viewApp quote color attribution



-- APP


viewApp : Quote -> String -> Attribution -> H.Html Msg
viewApp quote color =
    viewLayout color << viewContent quote


viewLayout : String -> H.Html msg -> H.Html msg
viewLayout color content =
    H.div
        [ HA.class "layout" ]
        [ globalCustomProperties [ ( "primary-color", color ) ]
        , H.div [ HA.class "layout__content" ] [ content ]
        ]


globalCustomProperties : List ( String, String ) -> H.Html msg
globalCustomProperties =
    List.map (\( name, value ) -> "--" ++ name ++ ": " ++ value ++ ";")
        >> String.join " "
        >> (\s -> H.node "style" [] [ H.text <| ":root { " ++ s ++ " }" ])


viewContent : Quote -> Attribution -> H.Html Msg
viewContent quote attribution =
    H.div [ HA.class "content" ]
        [ H.main_ [ HA.class "content__card" ] [ viewCard quote ]
        , H.footer
            [ HA.class "content__attribution" ]
            [ viewAttribution attribution ]
        ]



-- CARD


viewCard : Quote -> H.Html Msg
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


viewActions : Quote -> H.Html Msg
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
                , onClick = ClickedNewQuote
                }
            ]
        ]



-- BUTTONS


type alias ButtonOptions msg =
    { text : String
    , title : String
    , onClick : msg
    }


viewButton : ButtonOptions msg -> H.Html msg
viewButton { text, title, onClick } =
    H.button
        [ HA.class "button"
        , HA.title title
        , HE.onClick onClick
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
