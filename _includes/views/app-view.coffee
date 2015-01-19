class app.views.App extends Backbone.View
  el: '#app'
  
  initialize: ->
    @template = _.template($('#appTemplate').html())
    @render()

  render: ->
    compiled = @template()
    @$el.html(compiled)

    @$el.find('#mr_table').dataTable(@table_options())

  table_options: =>
    data: @collection.toJSON(),
    columns: [{
      data: 'open_project_id',
      title: 'Open Project ID'
    }, {
      data: 'undp_role_type',
      title: 'Role'
    }, {
      data: 'region',
      title: 'Region'
    }, {
      data: 'host_location',
      title: 'Location'
    }, {
      data: 'partner_type',
      title: 'Partners'
    }]
