module Calculations exposing(..)

import Model exposing (AlphaAcidPercentage, HopVariety(..), Recipe)

hopVarietyAlphaAcid : HopVariety -> AlphaAcidPercentage
hopVarietyAlphaAcid hopVariety =
  case hopVariety of
    Cascade ->
      5.25

recipeIbus : Recipe -> Float
recipeIbus recipe = 0.4
