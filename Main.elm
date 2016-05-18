import Html exposing (Html, button, div, h2, input, span, text)
import Html.App as Html
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)
import String

-- MODEL
type alias AlphaAcidPercentage = Float
type MassUnit = Ounce
type TimeUnit = Minute
type HopVariety = Cascade

type alias MassAmount =
  { value: Float
  , massUnit: MassUnit
  }

type alias TimeAmount =
  { value: Float
  , timeUnit: TimeUnit
  }

type alias HopAddition =
  { amount: MassAmount
  , boilTime: TimeAmount
  , hopVariety: HopVariety
  }
type alias Recipe =
  { hopAdditions: List HopAddition
  }
type alias Model = Recipe

initialHopAddition =
  { amount = { value = 1, massUnit = Ounce }
  , hopVariety = Cascade
  , boilTime = { value = 60, timeUnit = Minute }
  }

initialModel =
  { hopAdditions = [initialHopAddition]
  }

-- CALCULATIONS
hopVarietyAlphaAcid : HopVariety -> AlphaAcidPercentage
hopVarietyAlphaAcid hopVariety =
  case hopVariety of
    Cascade ->
      5.25

-- http://howtobrew.com/book/section-1/hops/hop-bittering-calculations
hopAdditionUtilization : HopAddition -> Float
hopAdditionUtilization hopAddition =
  let
    boilGravity = 1.050 --TODO: don't hardcode
    gravityFactor = 1.65 * 0.000125^(boilGravity - 1)
    timeFactor = (1 - e^(-0.04 * boilMinutes)) / 4.15
    boilMinutes =
      case hopAddition.boilTime.timeUnit of
        Minute ->
          hopAddition.boilTime.value
  in
    gravityFactor * timeFactor

hopAdditionIbus : HopAddition -> Float
hopAdditionIbus hopAddition =
  let
    alphaAcidPercentage = hopVarietyAlphaAcid hopAddition.hopVariety
    alphaAcidUnits = alphaAcidPercentage * weightInOunces
    recipeGallons = 5
    utilization = hopAdditionUtilization hopAddition
    weightInOunces =
      case hopAddition.amount.massUnit of
        Ounce ->
          hopAddition.amount.value
  in
    alphaAcidUnits * utilization * 75 / recipeGallons


recipeIbus : Recipe -> Float
recipeIbus recipe =
  let
    hopAdditions = recipe.hopAdditions
  in
    List.sum <| List.map hopAdditionIbus hopAdditions

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

type Msg = AddNewHopAddition | SetHopAdditionAmount String

update : Msg -> Model -> Model
update msg model =
  case msg of
    AddNewHopAddition ->
      let
        oldHopAdditions = model.hopAdditions
      in
        { model | hopAdditions = oldHopAdditions ++ [initialHopAddition] }
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
    , button [ onClick AddNewHopAddition ] [ text "Add new hop addition" ]
    ]

main =
  Html.beginnerProgram { model = initialModel, view = view, update = update }
