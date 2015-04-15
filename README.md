# UNDP SSC Mapping and data explorer

See `README.md` in [`admin_scripts`](admin_scripts/README.md) for admin scripts.

Based on http://open.undp.org.

Takes a subset of data, adds additional attributes.

## Globals

- **`app`** has properties set in only `script.coffee` (`projects`, `filters`, `state` and `router`) and `utils.coffee` (`utils`).

- **`preloadData`** contains `countries` and `indices` data bootstrapped into `index.html` on page load.


## Map data

Additional field `map_name` added where there is a mismatch between official name and that available in the mapping data.
