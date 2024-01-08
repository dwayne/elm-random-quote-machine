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
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Model =
    { quotes : NonEmptyList Quote
    , colors : NonEmptyList Color
    , selection : Selection
    }


type alias Color =
    String


type alias Selection =
    { quote : Quote
    , color : Color
    }


init : String -> ( Model, Cmd Msg )
init url =
    let
        quotes =
            defaultQuotes

        colors =
            defaultColors
    in
    ( { quotes = quotes
      , colors = colors
      , selection =
            { quote = NonEmptyList.head quotes
            , color = NonEmptyList.head colors
            }
      }
    , Cmd.batch
        [ generateNewSelection quotes colors
        , API.getQuotes GotQuotes url
        ]
    )



-- UPDATE


type Msg
    = ClickedNewQuote
    | GeneratedNewSelection Selection
    | GotQuotes (Result Http.Error (List Quote))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedNewQuote ->
            ( model
            , generateNewSelection model.quotes model.colors
            )

        GeneratedNewSelection selection ->
            ( { model | selection = selection }
            , Cmd.none
            )

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


generateNewSelection : NonEmptyList Quote -> NonEmptyList Color -> Cmd Msg
generateNewSelection quotes colors =
    Random.generate GeneratedNewSelection <|
        Random.map2 Selection
            (NonEmptyList.uniform quotes)
            (NonEmptyList.uniform colors)



-- VIEW


view : Model -> H.Html Msg
view { selection } =
    viewLayout selection.color <|
        viewMain
            { card =
                viewCard
                    { quote = viewQuote selection
                    , actions =
                        viewActions
                            [ viewIconButton Twitter selection
                            , viewIconButton Tumblr selection
                            , viewButton
                                { backgroundColor = selection.color
                                , onClick = ClickedNewQuote
                                , title = "Select a new random quote to display"
                                , text = "New quote"
                                }
                            ]
                    }
            , attribution =
                viewAttribution
                    { name = "dwayne"
                    , url = "https://github.com/dwayne"
                    }
            }


viewLayout : Color -> H.Html msg -> H.Html msg
viewLayout backgroundColor body =
    H.div
        [ HA.class "layout"
        , HA.style "background-color" backgroundColor
        ]
        [ H.div [ HA.class "layout__wrapper" ]
            [ H.div [ HA.class "layout__main" ]
                [ body ]
            ]
        ]


viewMain :
    { card : H.Html msg
    , attribution : H.Html msg
    }
    -> H.Html msg
viewMain { card, attribution } =
    H.main_ [ HA.class "main" ]
        [ H.div [ HA.class "main__card" ] [ card ]
        , H.div [ HA.class "main__attribution" ] [ attribution ]
        ]


viewCard :
    { quote : H.Html msg
    , actions : H.Html msg
    }
    -> H.Html msg
viewCard { quote, actions } =
    H.div [ HA.class "card" ]
        [ H.div [ HA.class "card__quote" ] [ quote ]
        , H.div [ HA.class "card__actions" ] [ actions ]
        ]


viewQuote : Selection -> H.Html msg
viewQuote { quote, color } =
    H.figure
        [ HA.class "quote"
        , HA.style "color" color
        ]
        [ H.blockquote
            [ HA.class "quote__content" ]
            [ H.p
                [ HA.class "quote__text" ]
                [ H.span
                    [ HA.class "quote__mark" ]
                    [ H.i [ HA.class "fas fa-quote-left" ] [] ]
                , H.text quote.text
                ]
            ]
        , H.figcaption
            [ HA.class "quote__attribution" ]
            [ H.text "— "
            , H.cite
                [ HA.class "quote_author" ]
                [ H.text quote.author ]
            ]
        ]


viewActions : List (H.Html msg) -> H.Html msg
viewActions actions =
    let
        viewAction action =
            H.div [ HA.class "actions__action" ] [ action ]
    in
    actions
        |> List.map viewAction
        |> H.div [ HA.class "actions" ]


type SocialMedia
    = Twitter
    | Tumblr


viewIconButton : SocialMedia -> Selection -> H.Html msg
viewIconButton socialMedia { quote, color } =
    let
        ( name, title, url ) =
            case socialMedia of
                Twitter ->
                    ( "twitter"
                    , "Twitter"
                    , twitterUrl quote
                    )

                Tumblr ->
                    ( "tumblr"
                    , "Tumblr"
                    , tumblrUrl quote
                    )
    in
    H.a
        [ HA.href url
        , HA.target "_blank"
        , HA.title <| "Share on " ++ title
        , HA.class "icon-button"
        , HA.style "background-color" color
        ]
        [ H.i [ HA.class <| "fab fa-" ++ name ] [] ]


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


viewButton :
    { backgroundColor : Color
    , onClick : msg
    , title : String
    , text : String
    }
    -> H.Html msg
viewButton { backgroundColor, onClick, title, text } =
    H.button
        [ HA.class "button"
        , HA.title title
        , HA.style "background-color" backgroundColor
        , HE.onClick onClick
        ]
        [ H.text text ]


viewAttribution :
    { name : String
    , url : String
    }
    -> H.Html msg
viewAttribution { name, url } =
    H.p
        [ HA.class "attribution" ]
        [ H.text "by "
        , H.a
            [ HA.href url
            , HA.class "attribution__link"
            ]
            [ H.text name ]
        ]



-- DATA


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


defaultColors : NonEmptyList Color
defaultColors =
    NonEmptyList.fromList
        "#16a085"
        [ "#27ae60"
        , "#2c3e50"
        , "#f39c12"
        , "#e74c3c"
        , "#9b59b6"
        , "#fb6964"
        , "#342224"
        , "#472e32"
        , "#bdbb99"
        , "#77b1a9"
        , "#73a857"
        ]
