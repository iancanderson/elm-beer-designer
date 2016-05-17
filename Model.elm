module Model exposing(..)

type alias AlphaAcidPercentage = Float
type MassUnit = Ounce
type TimeUnit = Minute
type HopVariety = Cascade

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
type alias Recipe =
  { hopAdditions: List HopAddition
  }
type alias Model = Recipe

initialHopAddition =
  { amount = { value = 1, massUnit = Ounce }
  , hopVariety = Cascade
  , boilTime = { value = 60, timeUnit = Minute }
  }
initialModel =
  { hopAdditions = [initialHopAddition]
  }
