module Carpenter.Router
  ( match
  , (:->)
  , router
  , Action
  , Route
  , RouterProps
  ) where

import Prelude
import Carpenter (Render, Update, EventHandler, spec)
import Carpenter.Router.LocationWatcher (locationWatcher, Location)
import Control.Alt ((<|>))
import Control.Monad.Eff.Class (liftEff)
import Data.Maybe (fromMaybe, Maybe(..))
import Data.Tuple (Tuple(Tuple), snd)
import React (ReactElement, createFactory, createClass, ReactClass)

foreign import _find :: ∀ a. (∀ b. b -> Maybe b) -> (∀ b. Maybe b) -> (a -> Boolean) -> Array a -> Maybe a

find :: ∀ a. (a -> Boolean) -> Array a -> Maybe a
find = _find Just Nothing

data Action = Change Location

type Route = String

type RouterProps a =
  { onChange :: a -> EventHandler
  , match :: Route -> a
  }

match :: ∀ a. Array (Tuple Route a) -> a -> Route -> a
match routes default route = fromMaybe default $ map snd $ find (\(Tuple r a) -> r == route) routes

infixl 1 Tuple as :->

initialLocation :: Location
initialLocation = { origin: "", pathname: "", search: "", hash: "" }

router :: ∀ a. (a -> EventHandler) -> (Route -> a) -> ReactElement
router onChange match' = createFactory routerComponent {onChange: onChange, match: match'}

routerComponent :: ∀ a. ReactClass (RouterProps a)
routerComponent = createClass $ spec initialLocation update render

update :: ∀ a eff. Update Location (RouterProps a) Action eff
update yield dispatch action props state = case action of
  Change location -> do
    liftEff $ props.onChange (props.match location.hash)
    yield $ const location

render :: ∀ a. Render Location (RouterProps a) Action
render dispatch _ _ _ = locationWatcher (dispatch <<< Change)
