---
---
window.app ?= {}
app.config = 
  initialViewState: 'map'
  repo: '{{ site.editor.github_repo }}'
  editor:
    url: '{{ site.editor.url }}'

# Models and Collections
{% include models/filter.coffee %}
{% include models/map-country.coffee %}
{% include models/project.coffee %}
{% include models/present-project.coffee %}
{% include collections/filters.coffee %}
{% include collections/map-countries.coffee %}
{% include collections/projects.coffee %}
{% include collections/projects-facets.coffee %} # Mixin on Projects Collection
{% include collections/admin-projects.coffee %} # Mixin on Projects Collection

# Controllers and ViewModels
{% include controllers/state-model.coffee %}

# Views
{% include views/project-view.coffee %}
{% include views/explorer-view.coffee %}
{% include views/search-view.coffee %}
{% include views/filter-view.coffee %}
{% include views/content-view.coffee %}
{% include views/map-view.coffee %}
{% include views/stats-view.coffee %}
{% include views/list-view.coffee %}
{% include views/controls-view.coffee %}
{% include views/headlines-view.coffee %}
{% include views/admin-view.coffee %}

# Controllers
{% include routers/router.coffee %} # Router

# Utilities
{% include utils/utils.coffee %}
{% include utils/console.coffee %} # Ensure 'console' exists, for IE8

# Launch
{% include app.coffee %}
