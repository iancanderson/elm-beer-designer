import Html exposing (Html, button, div, h2, input, span, text)
import Html.App as App
import Html.Events exposing (onClick, onInput)
import String

import Calculations exposing(recipeIbus)
import HopAddition
import Model exposing(ID, Model)

initialModel =
  { hopAdditions = []
  , nextHopAdditionId = 0
  }

type Msg = AddNewHopAddition | UpdateHopAddition ID HopAddition.Msg

update : Msg -> Model -> Model
update msg model =
  case msg of
    AddNewHopAddition ->
      let
        newHopAddition =
          (
            model.nextHopAdditionId,
            HopAddition.initialHopAddition
          )
        newHopAdditions = model.hopAdditions ++ [newHopAddition]
      in
        Model newHopAdditions (model.nextHopAdditionId + 1)
    UpdateHopAddition id hopAdditionMsg ->
      let
        updateHopAddition (hopAdditionID, hopAdditionModel) =
          if hopAdditionID == id then
            (hopAdditionID, HopAddition.update hopAdditionMsg hopAdditionModel)
          else
            (hopAdditionID, hopAdditionModel)
      in
        { model | hopAdditions = List.map updateHopAddition model.hopAdditions }

-- VIEW

hopAdditionView : (ID, HopAddition.Model) -> Html Msg
hopAdditionView (id, model) =
  App.map (UpdateHopAddition id) (HopAddition.view model)

hopAdditionsView : Model -> Html Msg
hopAdditionsView model =
  let
    heading = h2 [] [ text "Hop Additions" ]
    rows = List.map hopAdditionView model.hopAdditions
  in
    div [] <| heading :: rows

recipeSummary : Model -> Html Msg
recipeSummary model =
  let
    ibuDisplay = "IBUs: " ++ roundedIbu
    roundedIbu = toString <| round <| recipeIbus model
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

main =
  App.beginnerProgram { model = initialModel, view = view, update = update }
