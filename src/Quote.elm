module Quote exposing (Quote, decoder)

import Json.Decode as JD


type alias Quote =
    { text : String
    , author : String
    }


decoder : JD.Decoder Quote
decoder =
    JD.map2 Quote
        (JD.field "text" JD.string)
        (JD.field "author" JD.string)
