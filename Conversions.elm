module Conversions exposing (gallons)

import Units exposing (Volume, VolumeUnit(..))


gallons : Volume -> Float
gallons volume =
    case volume.unit of
        Gallon ->
            volume.value
