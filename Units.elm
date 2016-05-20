module Units exposing(Volume, VolumeUnit(..))

type VolumeUnit = Gallon

type alias Volume =
  { value: Float
  , unit: VolumeUnit
  }
