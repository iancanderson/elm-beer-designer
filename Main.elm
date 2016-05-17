import Html exposing (Html, button, div, text)
import Html.App as Html
import Html.Events exposing (onClick)

main =
  Html.beginnerProgram { model = initialModel, view = view, update = update }


-- MODEL

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

-- UPDATE

addHopAdditionAmount : Model -> Float -> Model
addHopAdditionAmount model delta =
  let
    oldHopAddition = Maybe.withDefault initialHopAddition <| List.head model.hopAdditions
    oldAmount = oldHopAddition.amount
    oldValue = oldAmount.value
  in
    { hopAdditions = [
        { oldHopAddition | amount = { oldAmount | value = oldValue + delta } }
      ]
    }

type Msg = IncreaseHopAdditionMass | DecreaseHopAdditionMass

update : Msg -> Model -> Model
update msg model =
  case msg of
    IncreaseHopAdditionMass ->
      addHopAdditionAmount model 1

    DecreaseHopAdditionMass ->
      addHopAdditionAmount model -1

-- VIEW

--TODO
hopAmountDisplay : Model -> String
hopAmountDisplay _ = "1 ounces"

hopAdditionView : HopAddition -> Html Msg
hopAdditionView hopAddition =
  div []
    [ button [ onClick DecreaseHopAdditionMass ] [ text "-" ]
    , text <| toString hopAddition.amount.value
    , button [ onClick IncreaseHopAdditionMass ] [ text "+" ]
    , text " "
    , text <| toString hopAddition.amount.weightUnit
    , text " "
    , text <| toString hopAddition.hopVariety
    ]

view : Model -> Html Msg
view model =
  div [] <| List.map hopAdditionView model.hopAdditions
