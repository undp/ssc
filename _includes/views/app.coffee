class app.views.App extends Backbone.View
  el: '#app'
  
  initialize: ->
    console.log "My collection is #{@collection.length} long"
    @template = _.template($('#appTemplate').html())
    @render()

  render: ->
    compiled = @template()
    @$el.html(compiled)
    @$el.find('#mr_table').dataTable({
      data: @collection.toJSON(),
      responsive: true,
      columns: [{
        data: 'undp_role_type',
        title: 'Role'
      }, {
        data: 'region',
        title: 'Region'
      }, {
        data: 'open_project_id',
        title: 'Project ID'
      }, {
        data: 'host_location',
        title: 'Location'
      }, {
        data: 'partner_type',
        title: 'Partners'
      }, ]
    })
