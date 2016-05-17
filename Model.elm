module Model exposing(..)

type alias AlphaAcidPercentage = Float
type MassUnit = Ounce
type HopVariety = Cascade
type alias Amount =
  { value: Float
  , weightUnit: MassUnit
  }
type alias HopAddition =
  { amount: Amount
  , hopVariety: HopVariety
  }
type alias Recipe =
  { hopAdditions: List HopAddition
  }
type alias Model = Recipe

initialHopAddition =
  { amount = { value = 1, weightUnit = Ounce }
  , hopVariety = Cascade
  }
initialModel =
  { hopAdditions = [initialHopAddition]
  }
