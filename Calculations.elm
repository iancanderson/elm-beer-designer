module Calculations exposing (recipeIbus)

import HopAddition exposing(HopVariety(..), MassUnit(..), TimeUnit(..))
import Model exposing(ID, Model)

type alias AlphaAcidPercentage = Float

hopVarietyAlphaAcid : HopVariety -> AlphaAcidPercentage
hopVarietyAlphaAcid hopVariety =
  case hopVariety of
    Cascade -> 5.25
    Chinook -> 13
    Citra   -> 12
    Fuggle  -> 4.5

-- http://howtobrew.com/book/section-1/hops/hop-bittering-calculations
hopAdditionUtilization : HopAddition.Model -> Float
hopAdditionUtilization hopAddition =
  let
    boilGravity = 1.050 --TODO: don't hardcode
    gravityFactor = 1.65 * 0.000125^(boilGravity - 1)
    timeFactor = (1 - e^(-0.04 * boilMinutes)) / 4.15
    boilMinutes =
      case hopAddition.boilTime.timeUnit of
        Minute ->
          hopAddition.boilTime.value
  in
    gravityFactor * timeFactor

hopAdditionIbus : ( ID, HopAddition.Model ) -> Float
hopAdditionIbus ( id, hopAddition ) =
  let
    alphaAcidPercentage = hopVarietyAlphaAcid hopAddition.hopVariety
    alphaAcidUnits = alphaAcidPercentage * weightInOunces
    recipeGallons = 5
    utilization = hopAdditionUtilization hopAddition
    weightInOunces =
      case hopAddition.amount.massUnit of
        Ounce ->
          hopAddition.amount.value
  in
    alphaAcidUnits * utilization * 75 / recipeGallons


recipeIbus : Model -> Float
recipeIbus recipe =
  let
    hopAdditions = recipe.hopAdditions
  in
    List.sum <| List.map hopAdditionIbus hopAdditions


