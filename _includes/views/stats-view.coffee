class StatsView extends Backbone.View
  template: -> _.template($('#statsView').html())

  initialize: ->
    @listenTo @collection, 'reset', @render
    _.template.partial.declare('stackedBarView', $('#partial-stackedBarView').html())

  render: ->
    compiled = @template()(
      collection: @collection
      stats: @_calculateStats()
    )
    @$el.html(compiled)
    @$el.find('.tooltip').tooltipster(theme: 'tooltipster-light')
    @

  _calculateStats: ->
    themeArray: @_createArrayFor('thematic_focus')
    roleArray: @_createArrayFor('undp_role_type')
    partnerArray: @_createArrayFor('partner_type')

  _createArrayFor: (type) ->
    raw = app.projects.prepareFilterGroupForType(type)

    total = _.inject(raw, (memo, value) -> 
      memo + value.activeCount
    , 0)
    
    _.map(raw, (i, index, list) =>
      value    = (i.activeCount / total) * 100
      position = index / list.length
      
      return {
        name: i.value
        type: type
        value: value
        colour: @_colourFor(type, position)
        long: i.long
      }
      
    )


  _colourFor: (type, position) ->
    rgbStart = '#528B9A'
    rgbEnd   = '#EFEE69'
    chroma.interpolate(rgbStart, rgbEnd, position, 'lch').hex()

