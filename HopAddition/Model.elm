module HopAddition.Model
    exposing
        ( HopAddition
        , HopVariety(..)
        , MassUnit(..)
        , TimeUnit(..)
        , TimeValue
        , init
        , MassAmount
        )


type HopVariety
    = Amarillo
    | Cascade
    | Centennial
    | Challenger
    | Chinook
    | Citra
    | Columbus
    | Crystal
    | Fuggle
    | Galaxy
    | Hallertau
    | Magnum
    | Mosaic
    | MountHood
    | MountRainier
    | NorthernBrewer
    | Nugget
    | Perle
    | Saaz
    | Simcoe
    | SorachiAce
    | Sterling
    | Summit
    | Tettnang
    | Tomahawk
    | Warrior
    | Willamette
    | Zeus


type MassUnit
    = Ounce


type TimeUnit
    = Minute


type alias MassAmountValue =
    Float


type alias MassAmount =
    { value : Maybe MassAmountValue
    , massUnit : MassUnit
    , input : String
    }


type alias TimeValue =
    Float


type alias TimeAmount =
    { value : TimeValue
    , timeUnit : TimeUnit
    }


type alias HopAddition =
    { amount : MassAmount
    , boilTime : TimeAmount
    , isDeleted : Bool
    , variety : HopVariety
    }


type alias Model =
    HopAddition


init =
    { amount = { value = Just 1, massUnit = Ounce, input = "1.0" }
    , variety = Cascade
    , boilTime = { value = 60, timeUnit = Minute }
    , isDeleted = False
    }
