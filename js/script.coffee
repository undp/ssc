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

# Controllers
{% include routers/router.coffee %}

$(document).ready ->
  window.projects = new Projects(ssc_data)
  window.connections = new Connections(projects)
  window.countries = new Countries
  countries.fetch 
    success: ->
      window.router = new Router()
      Backbone.history.start()