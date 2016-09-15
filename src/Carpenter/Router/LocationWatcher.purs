module Carpenter.Router.LocationWatcher
  ( locationWatcher
  , Action
  , Location
  ) where

import Prelude
import React.DOM as R
import Carpenter (spec', EventHandler, Render, Update)
import Control.Monad.Eff.Class (liftEff)
import DOM (DOM) as DOM
import DOM.Event.Event (preventDefault) as DOM
import DOM.Event.EventTarget (addEventListener, eventListener) as DOM
import DOM.HTML (window) as DOM
import DOM.HTML.Event.EventTypes (hashchange, load) as DOM
import DOM.HTML.Location (origin, pathname, search, hash) as DOM
import DOM.HTML.Types (windowToEventTarget) as DOM
import DOM.HTML.Window (location) as DOM
import React (createFactory, ReactElement, createClass, ReactClass)

data Action
  = Init
  | ChangeHash String

type Location =
  { origin :: String
  , pathname :: String
  , search :: String
  , hash :: String
  }

type Props =
  { onChange :: Location -> EventHandler
  }

initialLocation :: Location
initialLocation = { origin: "", pathname: "", search: "", hash: "" }

locationWatcher :: (Location -> EventHandler) -> ReactElement
locationWatcher onChange = createFactory locationWatcherComponent {onChange: onChange}

locationWatcherComponent :: ReactClass Props
locationWatcherComponent = createClass $ spec' initialLocation Init update render

update :: ∀ eff. Update Location Props Action (dom :: DOM.DOM | eff)
update yield dispatch action props state = case action of
  Init -> do
    window <- liftEff $ DOM.window
    liftEff $ DOM.addEventListener (DOM.hashchange) (DOM.eventListener onHashChange) false (DOM.windowToEventTarget window)
    liftEff $ DOM.addEventListener (DOM.load) (DOM.eventListener onHashChange) false (DOM.windowToEventTarget window)
    state <- liftEff $ getState
    liftEff $ props.onChange state
    yield $ const state
  ChangeHash hash -> do
    let new = state { hash = hash }
    liftEff $ props.onChange new
    yield $ const new
  where
    onHashChange e = void $ do
      DOM.preventDefault e
      location <- DOM.window >>= DOM.location
      hash <- DOM.hash location
      dispatch $ ChangeHash hash

    getState = do
      location <- DOM.window >>= DOM.location
      origin <- DOM.origin location
      pathname <- DOM.pathname location
      search <- DOM.search location
      hash <- DOM.hash location
      pure $ { origin: origin, pathname: pathname, search: search, hash: hash }

render :: ∀ props. Render Location props Action
render _ _ _ _ = R.div' []
