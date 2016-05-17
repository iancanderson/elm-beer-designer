import Html exposing (Html, button, div, h2, span, text)
import Html.App as Html
import Html.Events exposing (onClick)

import Calculations exposing (recipeIbus)
import Model exposing (HopAddition, Model, Recipe, initialHopAddition, initialModel)

main =
  Html.beginnerProgram { model = initialModel, view = view, update = update }

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

hopAdditionView : HopAddition -> Html Msg
hopAdditionView hopAddition =
  div []
    [ button [ onClick DecreaseHopAdditionMass ] [ text "-" ]
    , text <| toString hopAddition.amount.value
    , button [ onClick IncreaseHopAdditionMass ] [ text "+" ]
    , text " "
    , text <| toString hopAddition.amount.massUnit
    , text " "
    , text <| toString hopAddition.hopVariety
    , text " boiled for "
    , text <| toString hopAddition.boilTime.value
    , text " "
    , text <| toString hopAddition.boilTime.timeUnit
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

