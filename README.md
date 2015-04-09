# UNDP SSC Mapping and data explorer

See `README.md` in [`admin_scripts`](admin_scripts/readme.md) for admin scripts.

Based on http://open.undp.org.

Takes a subset of data, adds additional attributes.

## Globals

- **`app`** has properties set in only `script.coffee` (`projects`, `filters`, `state` and `router`) and `utils.coffee` (`utils`).

- **`preloadData`** contains `countries` and `indices` data bootstrapped into `index.html` on page load.


## Map data

Additional field `map_name` added where there is a mismatch between official name and that available in the mapping data.



## Object models

**SAFE** - these are understood and make sense!
`Projects` collection - all projects, does very little
`StateManager` - persist and retrieve filter and view state

**NEED HELP** - have a place, but not yet fully implemented
`Router` - routes (currently does too much, handles state, and filters)
`Filters` collection - includes Countries info, but not Countries collection (need to simplify relationship with Countries collection)
`Countries` collection - special type of Filter (need to simplify relationship with Filters collection))
`FacetManager` - Facets functionality for a Projects collection (not yet fully abstracted from `Projects` collection)

**REMOVE** - nope
`FilterManager` - ? not sure what this is doing
`ExplorerViewModel` - ? not sure what this is doing






