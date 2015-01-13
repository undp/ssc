Projects = Backbone.Collection.extend({
  url: '/data.json',
  parseLocations: function() {
    this.each(function(i) {
      i.set('locations', i.get('location').match(/\w{1,3}/g));
    });
  },
  facetBy: function(facetName, value) {
    Facetr(this).facet(facetName).value(value);
  },
  clearFacets: function() {
    Facetr(this).clearValues();
  }
});

p = new Projects;
p.fetch();
