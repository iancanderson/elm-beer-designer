module Model exposing (BoilGravity, ID, Model)

import HopAddition.Model exposing (HopAddition)
import Units exposing(Volume)

type alias BoilGravity = Float
type alias ID = Int

type alias Model =
  { boilGravity: BoilGravity
  , hopAdditions: List ( ID, HopAddition )
  , nextHopAdditionId: ID
  , volume: Volume
  }
