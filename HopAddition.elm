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
  , hopVariety: HopVariety
  }

type alias Model = HopAddition

initialHopAddition =
  { amount = { value = 1, massUnit = Ounce }
  , hopVariety = Cascade
  , boilTime = { value = 60, timeUnit = Minute }
  }

type Msg = SetHopAdditionAmount String | SetHopAdditionVariety String

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetHopAdditionAmount stringValue ->
      let
        newValue = Result.withDefault 0 (String.toFloat stringValue)
        oldAmount = model.amount
      in
        { model | amount = { oldAmount | value = newValue } }
    SetHopAdditionVariety stringValue ->
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
        { model | hopVariety = newVariety }


--TODO: how to make sure this list is exhaustive??
hopVarieties : List HopVariety
hopVarieties = [ Cascade, Chinook, Citra, Fuggle ]

hopVarietyOptionView : HopVariety -> HopVariety -> Html Msg
hopVarietyOptionView selectedHopVariety hopVariety =
  let
    hopVarietyValue = toString hopVariety
    isSelected = hopVariety == selectedHopVariety
  in
    option
      [ selected isSelected, value hopVarietyValue ] [ text hopVarietyValue ]

hopVarietySelectView : Model -> Html Msg
hopVarietySelectView hopAddition =
  let
    selectedHopVariety = hopAddition.hopVariety
  in
    select
      [ onInput SetHopAdditionVariety ]
      <| List.map (hopVarietyOptionView selectedHopVariety) hopVarieties

view : Model -> Html Msg
view hopAddition =
  let
    amountValue = toString hopAddition.amount.value
  in
    div []
      [ input [ onInput SetHopAdditionAmount, value amountValue ] []
      , text <| toString hopAddition.amount.massUnit
      , text " "
      , hopVarietySelectView hopAddition
      , text " boiled for "
      , text <| toString hopAddition.boilTime.value
      , text " "
      , text <| toString hopAddition.boilTime.timeUnit
      ]
