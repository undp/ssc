# Data, models and attributes

## Globals

- **`app`** has properties set in only `script.coffee` (`projects`, `filters`, `state` and `router`) and `utils.coffee` (`utils`).

- **`preloadData`** contains `countries` and `indices` data bootstrapped into `index.html` on page load.


## Data from http://open.undp.org

Projects count as at this commit [`07d84a215...`](https://github.com/undp/undp.github.com/commit/07d84a2151a9f32e4341ad6fb4bae4a47f04f2e9)

Year | Count
-----|------
2010 | 886
2011 | 2879
2012 | 5801
2013 | 5654
2014 | 5359
2015 | 3621


## Map data

Additional field `map_name` added where there is a mismatch between official name and that available in the mapping data.
