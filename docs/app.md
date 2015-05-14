# Information for developers

Contents:

- [Deployment](#deployment) and backup
- [Development tools](#development-tools)
- [Application structure](#application-structure) folders, etc
- [Globals](#globals) used in application


## Deployment

Hosted on Github pages. 

Push any changes onto the `gh-pages` branch, and the site will be rebuilt and redeployed almost immediately.

### Backup deployment

As a backup hosting option, we used [Netlify](https://www.netlify.com), which gives a simple drag-drop upload of the site, and makes it available [here](https://ssc.netlify.com).

## Development tools

The awesome folks at [Browserstack](https://www.browserstack.com) helped out with a free account to simplify the testing across multiple devices.

![BrowserStack](https://www.dropbox.com/s/at96ozgj3vc64cw/Screenshot%202015-05-14%2015.35.03.png?dl=1)

## Application structure

- Built for vanilla [Jekyll](www.jekyllrb.com), to use Github pages hosting. See [`deploy.md`](docs/deploy.md) for information on deployment.
- It is a [Backbone](backbonejs.org) application written in [Coffeescript](coffeescript.org).
- Makes use of the [Backbone.Facetr](https://github.com/arillo/Backbone.Facetr) library to simplify filtering the data.

### Folder structure

- **_includes** - main Backbone application (see [below](#_includes))
- **_sass** - [SASS](http://sass-lang.com) files, compiled by Jekyll
- **_site** - compiled version of the site, created by Jeykll
- **_ssc_projects** - individual text files for each SSC project (see [`manage.md`](docs/manage.md) for managing data)
- **admin_scripts** - scripts used to wrangle the SSC data during development (*not in production*)
- **api** - two Jekyll template files to create `.json` and `.csv` versions of the projects in `_ssc_projects`
- **css** - external CSS files
- **docs** - documentation for managing the SSC site
- **ext** - external JavaScript files
- **images** - images
- **js** - contains a single file (`script.coffee`), which concatenates the contents of `_includes`
- **node_modules** - used by admin scripts (*not in production*)
- **CNAME** - used by Github pages for hosting
- **README.md** - basic Readme
- **_config.yml** - Jekyll configuration
- **index.html** - home for the application
- **package.json** - used by admin scripts (*not in production*)


#### `_includes`

- **app.coffee** - creates the application (`app` global), and performs first fetch of data
- **collections** - `Projects`, `Filters`, and some supporting Backbone Collections
- **controllers** - a Backbone Collection (and Model) for managing State
- **data** - JSON files for `countries` and `indices` in `preloadData`
- **models** - Backbone Model supporting the Collections
- **routers** - single router
- **static_views** - static page elements (currently just the intro text) to simplify editing
- **templates** - [Underscore templates](http://underscorejs.org/#template) for each `View`
- **utils** - e.g. ID generation
- **views** - Backbone Views
- **footer.html, head.html, header.html** - pages components included by `index.html`
- **templates.html** - concatenates all Underscore templates from `templates`


## Globals

Two global variables are used:

- `app` has properties set in only `script.coffee` (`projects`, `filters`, `state` and `router`) and `utils.coffee` (`utils`).
- `preloadData` contains the `countries` and `indices` data bootstrapped into `index.html` on page load.

