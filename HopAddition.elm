module HopAddition exposing(HopVariety(..), MassUnit(..), Model, Msg(..), TimeUnit(..), initialHopAddition, update, view)

import Html exposing (Html, div, input, span, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import String

type MassUnit = Ounce
type TimeUnit = Minute
type HopVariety = Cascade

type alias MassAmount =
  { value: Float
  , massUnit: MassUnit
  }

type alias TimeAmount =
  { value: Float
  , timeUnit: TimeUnit
  }

type alias HopAddition =
  { amount: MassAmount
  , boilTime: TimeAmount
  , hopVariety: HopVariety
  }

type alias Model = HopAddition

initialHopAddition =
  { amount = { value = 1, massUnit = Ounce }
  , hopVariety = Cascade
  , boilTime = { value = 60, timeUnit = Minute }
  }

type Msg = SetHopAdditionAmount String

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetHopAdditionAmount stringValue ->
    let
      newValue = Result.withDefault 0 (String.toFloat stringValue)
      oldAmount = model.amount
    in
      { model | amount = { oldAmount | value = newValue } }

view : Model -> Html Msg
view hopAddition =
  let
    amountValue = toString hopAddition.amount.value
  in
    div []
      [ input [ onInput SetHopAdditionAmount, value amountValue ] []
      , text <| toString hopAddition.amount.massUnit
      , text " "
      , text <| toString hopAddition.hopVariety
      , text " boiled for "
      , text <| toString hopAddition.boilTime.value
      , text " "
      , text <| toString hopAddition.boilTime.timeUnit
      ]
