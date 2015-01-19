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
{% include views/app-view.coffee %}

# Controllers
{% include routers/router.coffee %}

$(document).ready ->
  window.projects = new Projects(ssc_data)
  window.connections = new Connections(projects)
  router = new Router();
  Backbone.history.start();
