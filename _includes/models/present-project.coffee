class PresentProject
  constructor: (model) ->
    throw "No model" unless model
    @model = model
    @presented = @model.toJSON()
    @process()

  process: ->
    @presented.host_location = @processUsingFilter('host_location')
    @presented.partner_location = @processUsingFilter('partner_location')
    @presented.thematic_focus = @processUsingFilter('thematic_focus')
    @presented.partner_type = @processUsingFilter('partner_type')
    @presented.territorial_focus = @processWithoutFilter('territorial_focus')

  render: ->
    @presented

  processUsingFilter: (field) ->
    items = _.compact(@model.get(field))
    items.map (item) ->
      return [] unless item.length > 0
      indice = app.filters.get(item).toJSON()
      
      name: indice.name
      short: item.toLowerCase()
      filterTitle: indice.filterTitle

  processWithoutFilter: (field) ->
    @model.get(field).map (item) ->
      name: item