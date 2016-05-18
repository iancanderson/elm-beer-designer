module Update exposing (Msg(..), update)

import Model exposing(Model, Recipe, initialHopAddition)
import String

setHopAdditionAmount : Recipe -> String -> Model
setHopAdditionAmount recipe stringValue =
  let
    oldHopAddition = Maybe.withDefault initialHopAddition <| List.head recipe.hopAdditions
    oldAmount = oldHopAddition.amount
    newValue = Result.withDefault 0 (String.toFloat stringValue)
  in
    { hopAdditions = [
        { oldHopAddition | amount = { oldAmount | value = newValue } }
      ]
    }

type Msg = SetHopAdditionAmount String

update : Msg -> Model -> Model
update msg model =
  case msg of
    SetHopAdditionAmount stringValue ->
      setHopAdditionAmount model stringValue
