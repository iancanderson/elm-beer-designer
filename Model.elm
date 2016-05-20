module Model exposing (BoilGravity, ID, Model)

import HopAddition
import Units exposing(Volume)

type alias BoilGravity = Float
type alias ID = Int

type alias Model =
  { boilGravity: BoilGravity
  , hopAdditions: List ( ID, HopAddition.Model )
  , nextHopAdditionId: ID
  , volume: Volume
  }
