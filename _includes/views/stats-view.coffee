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
    types = ['territorial_focus', 'thematic_focus', 'undp_role_type', 'partner_type']
    # TODO: Check this is sensible - i.e. 
    #       - exclude filters where only one option
    #       - exclude filters where no options
    _.map types, (type) => 
      type: s.humanize(type)
      values: @_createArrayFor(type)

  _createArrayFor: (type) ->
    raw = app.projects.prepareFilterGroupForType(type)

    total = _.inject(raw, (memo, value) -> 
      memo + value.activeCount
    , 0)
    
    _.map(raw, (i, index, list) =>
      name: i.value
      proportion: (i.activeCount / total) * 100
      colour: @_colourFor(type, (index / list.length))
      long: i.long
    )

  _colourFor: (type, position) ->
    colours = _.findWhere(@_config, type: type)
    rgbStart = colours.rgbStart
    rgbEnd   = colours.rgbEnd
    chroma.interpolate(rgbStart, rgbEnd, position, 'lch').hex()

  _config: [
    type: 'region'
    rgbStart: '#fce0dd'
    rgbEnd:   '#c32489'
  ,
    type: 'territorial_focus'
    rgbStart: '#810F7C'
    rgbEnd:   '#BDC9E1'
  ,
    type: 'thematic_focus'
    rgbStart: '#37a257'
    rgbEnd:   '#e5f5e1'
  ,
    type: 'undp_role_type'
    rgbStart: '#c32489'
    rgbEnd:   '#fce0dd'
  ,
    type: 'partner_type'
    rgbStart: '#b10610'
    rgbEnd:   '#fef0da'
  ]

