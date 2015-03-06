class PresentProject
  constructor: (model) ->
    throw "No model" unless model
    @model = model
    @presented = @model.toJSON()
    @_process()

  _process: ->
    @presented.host_location = @_processUsingFilter('host_location')
    @presented.partner_location = @_processUsingFilter('partner_location')
    @presented.thematic_focus = @_processUsingFilter('thematic_focus')
    @presented.partner_type = @_processUsingFilter('partner_type')
    @presented.territorial_focus = @_processWithoutFilter('territorial_focus')

  render: ->
    @presented

  _processUsingFilter: (field) ->
    items = _.compact(@model.get(field))
    items.map (item) ->
      return [] unless item.length > 0
      indice = app.filters.get(item).toJSON()
      
      name: indice.name
      short: item.toLowerCase()
      filterTitle: indice.filterTitle

  _processWithoutFilter: (field) ->
    @model.get(field).map (item) ->
      name: item