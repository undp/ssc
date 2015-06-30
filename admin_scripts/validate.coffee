# Validates the project files created with the 'create_' scripts
# 
# 

fs = require 'fs'
path = require 'path'
yaml = require 'yaml-front-matter'
_ = require 'underscore'

# Load all the project files
# Pass each through a validator
# Log out those that fail, along with failing rule

rootPath = path.resolve(__dirname + '/../_ssc_projects/')

class Process
  constructor: ->
    @files = _.without(fs.readdirSync(rootPath), '.DS_Store').slice(40,41)

  processAll: ->
    _.each @files, (fileName) =>
        projectId = fileName.replace(/\.txt$/,'')
        filePath = path.resolve(rootPath, fileName)
        fileContent = fs.readFileSync(filePath, encoding: 'utf8')
        content = yaml.loadFront(fileContent)
        return @_processProject(content, projectId)

  _processProject: (project, projectId) ->
    console.log project
    # console.log _.values(project)
    
    # Check no null values
    values = _.values(project)
    _.each values, (value) ->

  _issueLog: (projectId, issue) ->
    console.log "#{projectId}: #{issue}"

    

process = new Process

process.processAll()