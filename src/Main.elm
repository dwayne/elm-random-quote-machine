module Main exposing (main)


import Browser
import Html as H
import Html.Attributes as HA
import Html.Events as HE
import NonEmptyList as NonEmptyList exposing (NonEmptyList)
import Random
import Url.Builder as UB


main : Program () Model Msg
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


type alias Quote =
  { text : String
  , author : String
  }


type alias Color =
  String


type alias Selection =
  { quote : Quote
  , color : Color
  }


init : () -> (Model, Cmd Msg)
init _ =
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
  , generateNewSelection quotes colors
  )


-- UPDATE


type Msg
  = ClickedNewQuote
  | GeneratedNewSelection Selection


update : Msg -> Model -> (Model, Cmd Msg)
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


generateNewSelection : NonEmptyList Quote -> NonEmptyList Color -> Cmd Msg
generateNewSelection quotes colors =
  Random.generate GeneratedNewSelection <|
    Random.map2 Selection
      (NonEmptyList.uniform quotes)
      (NonEmptyList.uniform colors)


-- VIEW


view : Model -> H.Html Msg
view { selection } =
  viewCentral selection.color <|
    viewColumn
      [ H.main_ []
          [ viewCard
              { top = viewQuote selection
              , bottom =
                  viewActions
                    [ viewButtonLink Twitter selection
                    , viewButtonLink Tumblr selection
                    , viewButton selection.color ClickedNewQuote "New quote"
                    ]
              }
          ]
      , H.footer []
          [ viewAttribution ]
      ]


viewCentral : Color -> H.Html msg -> H.Html msg
viewCentral backgroundColor body =
  H.div
    [ HA.class "central"
    , HA.style "background-color" backgroundColor
    ]
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
      H.li [ HA.class "actions__action" ] [ action ]
  in
  actions
    |> List.map viewAction
    |> H.ul [ HA.class "actions" ]


type SocialMedia
  = Twitter
  | Tumblr


viewButtonLink : SocialMedia -> Selection -> H.Html msg
viewButtonLink socialMedia { quote, color } =
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
    , HA.style "background-color" color
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


viewButton : Color -> msg -> String -> H.Html msg
viewButton backgroundColor onClick text =
  H.button
    [ HA.class "button"
    , HA.style "background-color" backgroundColor
    , HE.onClick onClick
    ]
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
