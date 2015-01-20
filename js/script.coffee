---
---
baseurl = "{{ site.baseurl }}"
app = {}

# Models and Collections
{% include models/project.coffee %}
{% include collections/countries.coffee %}
{% include collections/projects.coffee %}
{% include collections/connections.coffee %}

# Views
app.views = {}
{% include views/app-layout.coffee %}
{% include views/project-view.coffee %}
{% include views/explorer-view.coffee %}

# Controllers
{% include routers/router.coffee %}

$(document).ready ->
  app = window.app = {}
  app.projects = new Projects(ssc_data)
  _.defer(-> app.connections = new Connections(app.projects))
  app.countries = new Countries
  app.countries.fetch 
    success: ->
      app.router = new Router()
      Backbone.history.start()