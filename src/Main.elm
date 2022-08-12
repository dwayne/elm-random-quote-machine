module Main exposing (main)


import Browser
import Html as H


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
  {}


init : () -> (Model, Cmd msg)
init _ =
  ( {}
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
view _ =
  H.text "Hello, world!"
