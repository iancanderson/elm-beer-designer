module View exposing (view)

import Calculations exposing (recipeIbus)
import Model exposing (HopAddition, Model, Recipe)
import Update exposing (Msg(..))

import Html exposing (Html, button, div, h2, input, span, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)

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
    , button [ onClick AddNewHopAddition ] [ text "Add new hop addition" ]
    ]

