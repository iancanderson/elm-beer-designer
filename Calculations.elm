module Calculations exposing (recipeIbus)

import HopAddition.Model exposing(HopAddition, HopVariety(..), MassUnit(..), TimeUnit(..))
import Model exposing(BoilGravity, ID, Model)
import Conversions exposing(gallons)

type alias AlphaAcidPercentage = Float

hopVarietyAlphaAcid : HopVariety -> AlphaAcidPercentage
hopVarietyAlphaAcid hopVariety =
  case hopVariety of
    Cascade -> 5.25
    Chinook -> 13
    Citra   -> 12
    Fuggle  -> 4.5

-- http://howtobrew.com/book/section-1/hops/hop-bittering-calculations
hopAdditionUtilization : BoilGravity -> HopAddition -> Float
hopAdditionUtilization boilGravity hopAddition =
  let
    gravityFactor = 1.65 * 0.000125^(boilGravity - 1)
    timeFactor = (1 - e^(-0.04 * boilMinutes)) / 4.15
    boilMinutes =
      case hopAddition.boilTime.timeUnit of
        Minute ->
          hopAddition.boilTime.value
  in
    gravityFactor * timeFactor

hopAdditionIbus : Model -> ( ID, HopAddition ) -> Float
hopAdditionIbus recipe ( _, hopAddition ) =
  let
    alphaAcidPercentage = hopVarietyAlphaAcid hopAddition.variety
    alphaAcidUnits = alphaAcidPercentage * weightInOunces
    utilization = hopAdditionUtilization recipe.boilGravity hopAddition
    weightInOunces =
      case hopAddition.amount.massUnit of
        Ounce ->
          hopAddition.amount.value
  in
    alphaAcidUnits * utilization * 75 / gallons(recipe.volume)


recipeIbus : Model -> Float
recipeIbus recipe =
  let
    hopAdditions = recipe.hopAdditions
  in
    List.sum <| List.map (hopAdditionIbus recipe) hopAdditions


