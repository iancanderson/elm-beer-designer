module Calculations exposing (hopVarietyAlphaAcid, recipeIbus)

import HopAddition.Model exposing (HopAddition, HopVariety(..), MassUnit(..), TimeUnit(..))
import Model exposing (BoilGravity, ID, Model)
import Conversions exposing (gallons)


type alias AlphaAcidPercentage =
    Float


hopVarietyAlphaAcid : HopVariety -> AlphaAcidPercentage
hopVarietyAlphaAcid hopVariety =
    case hopVariety of
        Amarillo ->
            9.5

        Cascade ->
            5.25

        Centennial ->
            10.5

        Challenger ->
            7.5

        Chinook ->
            13

        Citra ->
            12

        Columbus ->
            16

        Crystal ->
            4.5

        Fuggle ->
            4.5

        Galaxy ->
            14.9

        Hallertau ->
            4.5

        Magnum ->
            13.5

        Mosaic ->
            12.5

        MountHood ->
            6.5

        MountRainier ->
            6

        NorthernBrewer ->
            9

        Nugget ->
            13

        Perle ->
            8

        Saaz ->
            3.75

        Simcoe ->
            13

        SorachiAce ->
            13

        Sterling ->
            7.5

        Summit ->
            18

        Tettnang ->
            4.5

        Tomahawk ->
            16

        Warrior ->
            16

        Willamette ->
            5

        Zeus ->
            15



-- http://howtobrew.com/book/section-1/hops/hop-bittering-calculations


hopAdditionUtilization : BoilGravity -> HopAddition -> Float
hopAdditionUtilization boilGravity hopAddition =
    let
        gravityFactor =
            1.65 * 0.000125 ^ (boilGravity - 1)

        timeFactor =
            (1 - e ^ (-0.04 * boilMinutes)) / 4.15

        boilMinutes =
            case hopAddition.boilTime.timeUnit of
                Minute ->
                    hopAddition.boilTime.value
    in
        gravityFactor * timeFactor


hopAdditionIbus : Model -> ( ID, HopAddition ) -> Float
hopAdditionIbus recipe ( _, hopAddition ) =
    let
        alphaAcidPercentage =
            hopVarietyAlphaAcid hopAddition.variety

        alphaAcidUnits =
            alphaAcidPercentage * weightInOunces

        utilization =
            hopAdditionUtilization recipe.boilGravity hopAddition

        weightInOunces =
            case hopAddition.amount.massUnit of
                Ounce ->
                    Maybe.withDefault 0 hopAddition.amount.value
    in
        alphaAcidUnits * utilization * 75 / gallons (recipe.volume)


recipeIbus : Model -> Float
recipeIbus recipe =
    let
        hopAdditions =
            recipe.hopAdditions
    in
        List.sum <| List.map (hopAdditionIbus recipe) hopAdditions
