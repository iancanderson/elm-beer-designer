import Html exposing (Html, button, div, h2, input, span, text)
import Html.App as Html
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)
import String

import Calculations exposing (recipeIbus)
import Model exposing (HopAddition, Model, Recipe, initialHopAddition, initialModel)

main =
  Html.beginnerProgram { model = initialModel, view = view, update = update }

-- UPDATE

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

-- VIEW

hopAdditionView : HopAddition -> Html Msg
hopAdditionView hopAddition =
  let
      amountValue = toString hopAddition.amount.value
  in
    div []
      [ input [ onInput SetHopAdditionAmount, value amountValue ] []
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

