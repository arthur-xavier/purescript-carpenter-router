## Module Carpenter.Router.LocationWatcher

#### `Action`

``` purescript
data Action
```

#### `Location`

``` purescript
type Location = { origin :: String, pathname :: String, search :: String, hash :: String }
```

#### `locationWatcher`

``` purescript
locationWatcher :: (Location -> EventHandler) -> ReactElement
```


