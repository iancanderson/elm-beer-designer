import Html exposing (Html, button, div, h2, input, span, text)
import Html.App as App
import Html.Events exposing (onClick, onInput)
import String

import HopAddition

-- MODEL
type alias AlphaAcidPercentage = Float
type alias ID = Int
type alias Model =
  { hopAdditions: List ( ID, HopAddition.Model )
  , nextHopAdditionId: ID
  }

initialModel =
  { hopAdditions = []
  , nextHopAdditionId = 0
  }

-- -- CALCULATIONS
-- hopVarietyAlphaAcid : HopVariety -> AlphaAcidPercentage
-- hopVarietyAlphaAcid hopVariety =
--   case hopVariety of
--     Cascade ->
--       5.25
--
-- -- http://howtobrew.com/book/section-1/hops/hop-bittering-calculations
-- hopAdditionUtilization : HopAddition -> Float
-- hopAdditionUtilization hopAddition =
--   let
--     boilGravity = 1.050 --TODO: don't hardcode
--     gravityFactor = 1.65 * 0.000125^(boilGravity - 1)
--     timeFactor = (1 - e^(-0.04 * boilMinutes)) / 4.15
--     boilMinutes =
--       case hopAddition.boilTime.timeUnit of
--         Minute ->
--           hopAddition.boilTime.value
--   in
--     gravityFactor * timeFactor
--
-- hopAdditionIbus : HopAddition -> Float
-- hopAdditionIbus hopAddition =
--   let
--     alphaAcidPercentage = hopVarietyAlphaAcid hopAddition.hopVariety
--     alphaAcidUnits = alphaAcidPercentage * weightInOunces
--     recipeGallons = 5
--     utilization = hopAdditionUtilization hopAddition
--     weightInOunces =
--       case hopAddition.amount.massUnit of
--         Ounce ->
--           hopAddition.amount.value
--   in
--     alphaAcidUnits * utilization * 75 / recipeGallons
--
--
-- recipeIbus : Recipe -> Float
-- recipeIbus recipe =
--   let
--     hopAdditions = recipe.hopAdditions
--   in
--     List.sum <| List.map hopAdditionIbus hopAdditions

-- UPDATE
-- setHopAdditionAmount : Recipe -> String -> Model
-- setHopAdditionAmount recipe stringValue =
--   let
--     oldHopAddition = Maybe.withDefault initialHopAddition <| List.head recipe.hopAdditions
--     oldAmount = oldHopAddition.amount
--     newValue = Result.withDefault 0 (String.toFloat stringValue)
--   in
--     { hopAdditions = [
--         { oldHopAddition | amount = { oldAmount | value = newValue } }
--       ]
--     }

type Msg = AddNewHopAddition | SetHopAdditionAmount ID HopAddition.Msg

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
    SetHopAdditionAmount id hopAdditionMsg ->
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
  App.map (SetHopAdditionAmount id) (HopAddition.view model)

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
    -- ibuDisplay = "IBUs: " ++ toString(recipeIbus recipe)
    ibuDisplay = "IBUS: TODO"
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
