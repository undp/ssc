class Connections
  db_name: 'ssc_connections'

  constructor: (projects) ->
    throw 'No projects' unless projects && projects.models.length > 0
    @projects = projects
    @db = levelgraph('ssc_connections')

    matrix = []
    @projects.each (project) =>
      @populateEach(project)
    @

  populateEach: (project) =>
    project_matrix = []
    project_id = project.get('id') || 'no project_id'

    # combine all locations
    locations = _.chain(project.get('host_location'), project.get('partner_location'))
      .flatten()
      .compact()
      .value()

    return unless locations.length > 1

    # create a node between countries, with project_id as property
    _.each locations, (location) =>
      subject = location
      objects = _.without(locations, location)

      _.each objects, (object) ->
        project_matrix.push {
          subject: subject,
          predicate: 'cooperates with',
          object: object,
          project_id: project_id
        }

      @db.put(project_matrix, (err) ->
        throw err if err
      )

  for: (iso3, callback) ->
    throw 'Provide ISO3 country ref' unless iso3 && iso3.length == 3
    throw 'Provide callback' unless callback
    @db.get(
      {subject: iso3.toUpperCase()},
      (err,list) -> 
        callback(list)
    )