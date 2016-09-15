## Module Carpenter.Router

#### `Action`

``` purescript
data Action
```

#### `Route`

``` purescript
type Route = String
```

#### `RouterProps`

``` purescript
type RouterProps a = { onChange :: a -> EventHandler, match :: Route -> a }
```

#### `match`

``` purescript
match :: forall a. Array (Tuple Route a) -> a -> Route -> a
```

#### `(:->)`

``` purescript
infixl 1 Data.Tuple.Tuple as :->
```

#### `router`

``` purescript
router :: forall a. (a -> EventHandler) -> (Route -> a) -> ReactElement
```


