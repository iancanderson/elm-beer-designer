module HopAddition exposing(HopVariety(..), MassUnit(..), Model, Msg(Delete), TimeUnit(..), initialHopAddition, update, view)

import Html exposing (Html, button, div, input, option, select, span, text)
import Html.Attributes exposing (selected, value)
import Html.Events exposing (onClick, onInput)
import String

type MassUnit = Ounce
type TimeUnit = Minute
type HopVariety = Cascade | Chinook | Citra | Fuggle

type alias MassAmountValue = Float
type alias MassAmount =
  { value: MassAmountValue
  , massUnit: MassUnit
  }

type alias TimeValue = Float
type alias TimeAmount =
  { value: TimeValue
  , timeUnit: TimeUnit
  }

type alias HopAddition =
  { amount: MassAmount
  , boilTime: TimeAmount
  , isDeleted: Bool
  , variety: HopVariety
  }

type alias Model = HopAddition

initialHopAddition =
  { amount = { value = 1, massUnit = Ounce }
  , variety = Cascade
  , boilTime = { value = 60, timeUnit = Minute }
  , isDeleted = False
  }

type Msg =
    Delete
  | SetAmount String
  | SetBoilTimeValue String
  | SetVariety String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Delete ->
      { model | isDeleted = True }

    SetAmount stringValue ->
      let
        newValue = Result.withDefault 0 (String.toFloat stringValue)
        oldAmount = model.amount
      in
        { model | amount = { oldAmount | value = newValue } }
    SetBoilTimeValue stringValue ->
      let
        newValue = Result.withDefault 0 (String.toFloat stringValue)
        oldBoilTime = model.boilTime
      in
        { model | boilTime = { oldBoilTime | value = newValue } }
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

varietyOption : HopVariety -> HopVariety -> Html Msg
varietyOption selectedVariety variety =
  let
    varietyValue = toString variety
    isSelected = variety == selectedVariety
  in
    option
      [ selected isSelected, value varietyValue ] [ text varietyValue ]

varietySelect : HopAddition -> Html Msg
varietySelect hopAddition =
  let
    selectedVariety = hopAddition.variety
  in
    select
      [ onInput SetVariety ]
      <| List.map (varietyOption selectedVariety) varieties

boilTimeValues : TimeValue -> TimeValue -> List TimeValue
boilTimeValues min max =
  if min == max then
    [min]
  else
    min :: boilTimeValues (min + 1) max

boilTimeValueOption : TimeValue -> TimeValue -> Html Msg
boilTimeValueOption selectedTimeValue timeValue =
  let
    isSelected = timeValue == selectedTimeValue
    timeValueString = toString timeValue
  in
    option
      [ selected isSelected, value timeValueString ]
      [ text timeValueString ]

boilTimeValueSelect : HopAddition -> Html Msg
boilTimeValueSelect hopAddition =
  let
    selectedTimeValue = hopAddition.boilTime.value
    values = boilTimeValues 0 90
  in
    select
      [ onInput SetBoilTimeValue ]
      <| List.map (boilTimeValueOption selectedTimeValue) values

view : Model -> Html Msg
view hopAddition =
  let
    amountValue = toString hopAddition.amount.value
  in
    div []
      [ input [ onInput SetAmount, value amountValue ] []
      , text <| toString hopAddition.amount.massUnit
      , text " "
      , varietySelect hopAddition
      , text " boiled for "
      , boilTimeValueSelect hopAddition
      , text " "
      , text <| toString hopAddition.boilTime.timeUnit
      , button [ onClick Delete ] [ text "Remove Hop Addition" ]
      ]
