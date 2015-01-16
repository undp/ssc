---
---
baseurl = "{{ site.baseurl }}"

# Models
{% include collections/countries.coffee %}
{% include collections/projects.coffee %}
{% include models/project.coffee %}

# Controllers
{% include routers/router.coffee %}

$(document).ready ->
  router = new Router();
  Backbone.history.start();
