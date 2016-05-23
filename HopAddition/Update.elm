module HopAddition.Update exposing (Msg(..), update)

import HopAddition.Model exposing(HopAddition, HopVariety(..))
import String

type Msg =
    Delete
  | SetAmount String
  | SetBoilTimeValue String
  | SetVariety String

update : Msg -> HopAddition -> HopAddition
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

