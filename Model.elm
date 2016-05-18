module Model exposing (ID, Model)

import HopAddition

type alias ID = Int
type alias Model =
  { hopAdditions: List ( ID, HopAddition.Model )
  , nextHopAdditionId: ID
  }
