import Html exposing (Html, button, div, h2, input, p, text)
import Html.App as App
import Html.Events exposing (onClick, onInput)
import String

import Calculations exposing(recipeIbus)
import HopAddition
import Model exposing(ID, Model)

initialModel =
  { boilGravity = 1.050
  , hopAdditions = []
  , nextHopAdditionId = 0
  }

type Msg =
    AddNewHopAddition
  | DeleteHopAddition ID
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
    DeleteHopAddition id ->
      let
        doesNotHaveId (otherId, _) = otherId /= id
      in
        { model | hopAdditions = List.filter doesNotHaveId model.hopAdditions }
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

hopAdditionMsgToMainMessage : ID -> HopAddition.Msg -> Msg
hopAdditionMsgToMainMessage id hopAdditionMsg =
  case hopAdditionMsg of
    HopAddition.Delete -> DeleteHopAddition id
    _ -> UpdateHopAddition id hopAdditionMsg

hopAdditionView : (ID, HopAddition.Model) -> Html Msg
hopAdditionView (id, model) =
  App.map (hopAdditionMsgToMainMessage id) (HopAddition.view model)

hopAdditionsView : Model -> Html Msg
hopAdditionsView model =
  let
    addButton = button [ onClick AddNewHopAddition ] [ text "Add new hop addition" ]
    heading = h2 [] [ text "Hop Additions" ]
    rows = List.map hopAdditionView model.hopAdditions
  in
    div [] ([heading, addButton] ++ rows)

recipeSummary : Model -> Html Msg
recipeSummary model =
  let
    ibuDisplay = "IBUs: " ++ roundedIbu
    roundedIbu = toString <| round <| recipeIbus model
  in
    div []
      [ h2 [] [ text "Recipe Summary" ]
      , p [] [ text <| "Boil Gravity: " ++ toString(model.boilGravity) ]
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
