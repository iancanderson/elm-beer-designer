module HopAddition exposing(HopVariety(..), MassUnit(..), Model, Msg(..), TimeUnit(..), initialHopAddition, update, view)

import Html exposing (Html, div, input, option, select, span, text)
import Html.Attributes exposing (selected, value)
import Html.Events exposing (onInput)
import String

type MassUnit = Ounce
type TimeUnit = Minute
type HopVariety = Cascade | Chinook | Citra | Fuggle

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
  , variety: HopVariety
  }

type alias Model = HopAddition

initialHopAddition =
  { amount = { value = 1, massUnit = Ounce }
  , variety = Cascade
  , boilTime = { value = 60, timeUnit = Minute }
  }

type Msg = SetAmount String | SetVariety String

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetAmount stringValue ->
      let
        newValue = Result.withDefault 0 (String.toFloat stringValue)
        oldAmount = model.amount
      in
        { model | amount = { oldAmount | value = newValue } }
    SetVariety stringValue ->
      --TODO how to pass the type itself into this action??
      let
        newVariety =
          case stringValue of
            "Cascade" -> Cascade
            "Chinook" -> Chinook
            "Citra" -> Citra
            "Fuggle" -> Fuggle
            _ -> Cascade
      in
        { model | variety = newVariety }


--TODO: how to make sure this list is exhaustive??
varieties : List HopVariety
varieties = [ Cascade, Chinook, Citra, Fuggle ]

varietyOptionView : HopVariety -> HopVariety -> Html Msg
varietyOptionView selectedVariety variety =
  let
    varietyValue = toString variety
    isSelected = variety == selectedVariety
  in
    option
      [ selected isSelected, value varietyValue ] [ text varietyValue ]

varietySelectView : Model -> Html Msg
varietySelectView hopAddition =
  let
    selectedHopVariety = hopAddition.variety
  in
    select
      [ onInput SetVariety ]
      <| List.map (varietyOptionView selectedHopVariety) varieties

view : Model -> Html Msg
view hopAddition =
  let
    amountValue = toString hopAddition.amount.value
  in
    div []
      [ input [ onInput SetAmount, value amountValue ] []
      , text <| toString hopAddition.amount.massUnit
      , text " "
      , varietySelectView hopAddition
      , text " boiled for "
      , text <| toString hopAddition.boilTime.value
      , text " "
      , text <| toString hopAddition.boilTime.timeUnit
      ]
