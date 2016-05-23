module HopAddition.Model exposing (HopAddition, HopVariety(..), MassUnit(..), TimeUnit(..), TimeValue, init)

type HopVariety = Cascade | Chinook | Citra | Fuggle
type MassUnit = Ounce
type TimeUnit = Minute

type alias MassAmountValue = Float
type alias MassAmount =
  { value: MassAmountValue
  , massUnit: MassUnit
  }

type alias TimeValue = Float
type alias TimeAmount =
  { value: TimeValue
  , timeUnit: TimeUnit
  }

type alias HopAddition =
  { amount: MassAmount
  , boilTime: TimeAmount
  , isDeleted: Bool
  , variety: HopVariety
  }

type alias Model = HopAddition

init =
  { amount = { value = 1, massUnit = Ounce }
  , variety = Cascade
  , boilTime = { value = 60, timeUnit = Minute }
  , isDeleted = False
  }


