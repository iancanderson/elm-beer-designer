module HopAddition.Update exposing (Msg(..), update)

import HopAddition.Model exposing (HopAddition, HopVariety(..), MassAmount)
import String


type Msg
    = Delete
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
                newValue =
                    Result.withDefault 0 (String.toFloat stringValue)

                newAmount =
                    case String.toFloat stringValue of
                        Err _ ->
                            MassAmount Nothing model.amount.massUnit stringValue

                        Ok newValue ->
                            MassAmount (Just newValue) model.amount.massUnit stringValue
            in
                { model | amount = newAmount }

        SetBoilTimeValue stringValue ->
            let
                newValue =
                    Result.withDefault 0 (String.toFloat stringValue)

                oldBoilTime =
                    model.boilTime
            in
                { model | boilTime = { oldBoilTime | value = newValue } }

        SetVariety stringValue ->
            --TODO how to pass the type itself into this action??
            let
                newVariety =
                    case stringValue of
                        "Cascade" ->
                            Cascade

                        "Chinook" ->
                            Chinook

                        "Citra" ->
                            Citra

                        "Fuggle" ->
                            Fuggle

                        _ ->
                            Cascade
            in
                { model | variety = newVariety }
