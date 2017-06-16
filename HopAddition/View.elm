module HopAddition.View exposing (view)

import Html exposing (Html, button, div, input, option, select, span, text)
import Html.Attributes exposing (selected, value)
import Html.Events exposing (onClick, onInput)
import HopAddition.Model exposing (HopAddition, HopVariety(..), TimeValue)
import HopAddition.Update exposing (Msg(..))
import Calculations exposing (hopVarietyAlphaAcid)
import HopAddition.Model exposing (HopAddition, HopVariety(..), TimeValue)
import HopAddition.Update exposing (Msg(..))


varietyOption : HopVariety -> HopVariety -> Html Msg
varietyOption selectedVariety variety =
    let
        varietyValue =
            toString variety

        varietyText =
            varietyValue ++ " (" ++ toString (hopVarietyAlphaAcid variety) ++ "% AA)"

        isSelected =
            variety == selectedVariety
    in
        option
            [ selected isSelected, value varietyValue ]
            [ text varietyText ]



--TODO: how to make sure this list is exhaustive??


varieties : List HopVariety
varieties =
    [ Amarillo
    , Cascade
    , Centennial
    , Challenger
    , Chinook
    , Citra
    , Columbus
    , Crystal
    , Fuggle
    , Galaxy
    , Hallertau
    , Magnum
    , Mosaic
    , MountHood
    , MountRainier
    , NorthernBrewer
    , Nugget
    , Perle
    , Saaz
    , Simcoe
    , SorachiAce
    , Sterling
    , Summit
    , Tettnang
    , Tomahawk
    , Warrior
    , Willamette
    , Zeus
    ]


varietySelect : HopAddition -> Html Msg
varietySelect hopAddition =
    let
        selectedVariety =
            hopAddition.variety
    in
        select
            [ onInput SetVariety ]
        <|
            List.map (varietyOption selectedVariety) varieties


boilTimeValues : TimeValue -> TimeValue -> List TimeValue
boilTimeValues min max =
    if min == max then
        [ min ]
    else
        min :: boilTimeValues (min + 1) max


boilTimeValueOption : TimeValue -> TimeValue -> Html Msg
boilTimeValueOption selectedTimeValue timeValue =
    let
        isSelected =
            timeValue == selectedTimeValue

        timeValueString =
            toString timeValue
    in
        option
            [ selected isSelected, value timeValueString ]
            [ text timeValueString ]


boilTimeValueSelect : HopAddition -> Html Msg
boilTimeValueSelect hopAddition =
    let
        selectedTimeValue =
            hopAddition.boilTime.value

        values =
            boilTimeValues 0 90
    in
        select
            [ onInput SetBoilTimeValue ]
        <|
            List.map (boilTimeValueOption selectedTimeValue) values


view : HopAddition -> Html Msg
view hopAddition =
    let
        amountValue =
            toString hopAddition.amount.value
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
