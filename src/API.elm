module API exposing (getQuotes)

import Http
import Json.Decode as JD
import Quote exposing (Quote)


getQuotes : (Result Http.Error (List Quote) -> msg) -> String -> Cmd msg
getQuotes toMsg url =
    Http.get
        { url = url
        , expect = Http.expectJson toMsg quotesDecoder
        }


quotesDecoder : JD.Decoder (List Quote)
quotesDecoder =
    JD.field "quotes" (JD.list Quote.decoder)
