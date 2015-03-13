class AdminView extends Backbone.View
  template: ->  _.template($('#adminView').html())

  events:
    'click .tab-menu-link': '_selectTabLink'

  initialize:  () ->
    _.template.partial.declare('adminTable', $('#partial-adminTable').html())
    @openProjects = new OpenProjects
    app.open = @openProjects # TODO: @prod remove global
    @openProjects.fetch
      success: =>
        @render()

  render: (options) =>
    compiled = @template()(
      possibleProjects: @openProjects.withoutExisting(@collection)
      existingProjects: @openProjects.presentExistingInAdmin(@collection)
      openProjects: @openProjects.toJSON()
    )
    @$el.html(compiled)  
    @_setActiveTab('possible')
    _.defer -> 
      $('.data-table').DataTable()
      $('.loading-holder').hide()

  _selectTabLink: (ev) =>
    ev.preventDefault()
    tab = ev.currentTarget.getAttribute('data-w-tab')
    @_setActiveTab(tab)

  _setActiveTab: (tab) ->
    linkActive = 'w--current'
    tabActive = 'w--tab-active'

    @$el.find('.tab-menu-link').removeClass(linkActive)
    @$el.find(".tab-menu-link[data-w-tab='#{tab}']").addClass(linkActive)

    @$el.find('.w-tab-pane').removeClass(tabActive)
    @$el.find(".w-tab-pane[data-w-tab='#{tab}']").addClass(tabActive)

    if @childViews? and @childViews[tab].setActive?
      @childViews[tab].setActive() 
    