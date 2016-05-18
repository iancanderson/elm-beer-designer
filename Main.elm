import Html.App as Html

import Model exposing (initialModel)
import Update exposing (update)
import View exposing (view)

main =
  Html.beginnerProgram { model = initialModel, view = view, update = update }
