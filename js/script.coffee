---
---
baseurl = "{{ site.baseurl }}"
app = {}

# Models and Collections
{% include models/project.coffee %}
{% include collections/countries.coffee %}
{% include collections/projects.coffee %}

# Views
app.views = {}
{% include views/app.coffee %}

# Controllers
{% include routers/router.coffee %}

$(document).ready ->
  router = new Router();
  Backbone.history.start();
