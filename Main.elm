import Html exposing (Html, button, div, h2, span, text)
import Html.App as Html
import Html.Events exposing (onClick)

main =
  Html.beginnerProgram { model = initialModel, view = view, update = update }


-- MODEL

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

-- MODEL CALCULATIONS

hopVarietyAlphaAcid : HopVariety -> AlphaAcidPercentage
hopVarietyAlphaAcid hopVariety =
  case hopVariety of
    Cascade ->
      5.25

recipeIbus : Recipe -> Float
recipeIbus recipe = 0.4

-- UPDATE

addHopAdditionAmount : Recipe -> Float -> Model
addHopAdditionAmount recipe delta =
  let
    oldHopAddition = Maybe.withDefault initialHopAddition <| List.head recipe.hopAdditions
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

hopAdditionsView : Recipe -> Html Msg
hopAdditionsView recipe =
  let
    heading = h2 [] [ text "Hop Additions" ]
    rows = List.map hopAdditionView recipe.hopAdditions
  in
    div [] <| heading :: rows

recipeSummary : Recipe -> Html Msg
recipeSummary recipe =
  let
    ibuDisplay = "IBUs: " ++ toString(recipeIbus recipe)
  in
    div []
      [ h2 [] [ text "Recipe Summary" ]
      , span [] [ text ibuDisplay ]
      ]

view : Model -> Html Msg
view model =
  div []
    [ recipeSummary model
    , hopAdditionsView model
    ]

