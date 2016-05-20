import Html exposing (Html, button, div, h2, input, p, text)
import Html.App as App
import Html.Events exposing (onClick, onInput)
import String

import Calculations exposing(recipeIbus)
import HopAddition
import Model exposing(ID, Model)
import Units exposing(VolumeUnit(Gallon))

initialModel =
  { boilGravity = 1.050
  , hopAdditions = []
  , nextHopAdditionId = 0
  , volume = { value = 5, unit = Gallon }
  }

type Msg =
    AddNewHopAddition
  | UpdateHopAddition ID HopAddition.Msg

update : Msg -> Model -> Model
update msg model =
  case msg of
    AddNewHopAddition ->
      let
        newHopAddition =
          ( model.nextHopAdditionId, HopAddition.initialHopAddition )
      in
        { model |
            hopAdditions = model.hopAdditions ++ [newHopAddition],
            nextHopAdditionId = model.nextHopAdditionId + 1 }
    UpdateHopAddition id hopAdditionMsg ->
      let
        updateAddition (hopAdditionID, hopAdditionModel) =
          if hopAdditionID == id then
            (hopAdditionID, HopAddition.update hopAdditionMsg hopAdditionModel)
          else
            (hopAdditionID, hopAdditionModel)

        updatedHopAdditions = List.map updateAddition model.hopAdditions
        isNotDeleted (id, hopAddition) = not hopAddition.isDeleted
      in
        { model | hopAdditions = List.filter isNotDeleted updatedHopAdditions }

-- VIEW

hopAdditionView : (ID, HopAddition.Model) -> Html Msg
hopAdditionView (id, model) =
  App.map (UpdateHopAddition id) (HopAddition.view model)

hopAdditionsView : Model -> Html Msg
hopAdditionsView model =
  let
    addButton = button [ onClick AddNewHopAddition ] [ text "Add new hop addition" ]
    heading = h2 [] [ text "Hop Additions" ]
    rows = List.map hopAdditionView model.hopAdditions
  in
    div [] ([heading, addButton] ++ rows)

recipeSummary : Model -> Html Msg
recipeSummary recipe =
  let
    ibuDisplay = "IBUs: " ++ roundedIbu
    roundedIbu = toString(round(recipeIbus recipe))
    volumeAmount = toString(recipe.volume.value)
    volumeUnit = toString(recipe.volume.unit)
    volumeDisplay = volumeAmount ++ " " ++ volumeUnit
  in
    div []
      [ h2 [] [ text "Recipe Summary" ]
      , p [] [ text <| "Batch Volume: " ++ volumeDisplay ]
      , p [] [ text <| "Boil Gravity: " ++ toString(recipe.boilGravity) ]
      , p [] [ text ibuDisplay ]
      ]

view : Model -> Html Msg
view model =
  div []
    [ recipeSummary model
    , hopAdditionsView model
    ]

main =
  App.beginnerProgram { model = initialModel, view = view, update = update }
