---
---
var util = {}; // util is on the Window level, since it needs to be accessed by the templates
{% include util.js %}

Countries = Backbone.Collection.extend({
  initialize: function(p) {
    var that = this;
    that.projects = p;
    that.counts = {};
    projects.each(function(i) {
      i.get('location').forEach(function(i) {
        var count = that.counts[i];
        that.counts[i] = count ? count + 1 : 1
      });
    });
  }
})

Projects = Backbone.Collection.extend({
  url: '{{ site.baseurl }} /api/projects.json'
  // parseLocations: function() {
  //   this.each(function(i) {
  //     i.set('locations', i.get('location').split(/,\s?/));
  //   });
  // },
  // facetBy: function(facetName, value) {
  //   Facetr(this).facet(facetName).value(value);
  // },
  // clearFacets: function() {
  //   Facetr(this).clearValues();
  // }
});


$(document).ready(function() {
  projects = new Projects;
  projects.fetch({success: renderTable});
});

function renderTable() {
  $('#mr_table').dataTable({
    data: projects.toJSON(),
    responsive: true,
    columns: [{
      data: 'role_of_undp',
      title: 'Role'
    }, {
      data: 'region',
      title: 'Region'
    }, {
      data: 'openProjectId',
      title: 'Project ID'
    }, {
      data: 'location',
      title: 'Location'
    }, {
      data: 'partner_types',
      title: 'Partners'
    }, ]
  });

}

// $.getJSON("/ssc_data/projects.json", function(data) {
//   c = new Backbone.Collection(data);
//   d = createLocationIndex(data);
//   return;
// })

// function createLocationIndex(data) {
//   var locations = [];
//   data.forEach(function(i) {
//     locations.push(i.location);
//   })
//   return _.chain(_.uniq(locations))
//     .map(function(i) {
//       return i.split(/,\s?/);
//     })
//     .flatten()
//     .map(function(i) {
//       return i.trim()
//     })
//     .unique()
//     .sort()
//     .value()
// }