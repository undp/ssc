class Countries extends Backbone.Collection
  initialize: (p) ->
    that = this
    that.projects = p
    that.counts = {}
    projects.each (i) ->
      i.get("location").forEach (i) ->
        count = that.counts[i]
        that.counts[i] = (if count then count + 1 else 1)
