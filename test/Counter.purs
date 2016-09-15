module Test.Counter where

import Prelude
import React.DOM as R
import React.DOM.Props as P
import Carpenter (Render, Update)
import Carpenter.Router (match, (:->), router, Route)
import Data.Char (fromCharCode)

data CounterType = Int | Char

data Action
  = Increment
  | Decrement
  | SetType CounterType

type Counter =
  { count :: Int
  , counterType :: CounterType
  }

routes :: Route -> CounterType
routes = match
  [ "#int" :-> Int
  , "#char" :-> Char
  ] Int

update :: forall props eff. Update Counter props Action eff
update yield _ action _ _ = case action of
  Increment ->
    yield $ \c -> c { count = c.count + 1 }

  Decrement ->
    yield $ \c -> c { count = c.count - 1 }

  SetType t ->
    yield $ _ { counterType = t }

render :: forall props. Render Counter props Action
render dispatch _ state _ =
  R.div'
    [ router (dispatch <<< SetType) routes
    , R.span' [ R.text count ]
    , R.button [ P.onClick \_ -> dispatch Increment ] [ R.text "+" ]
    , R.button [ P.onClick \_ -> dispatch Decrement ] [ R.text "-" ]
    , R.a [ P.href "#int" ] [ R.text "Int" ]
    , R.a [ P.href "#char" ] [ R.text "Char" ]
    ]
  where
    count = case state.counterType of
      Int -> show state.count
      Char -> show (fromCharCode state.count)
