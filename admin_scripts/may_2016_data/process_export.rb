#!/usr/bin/env ruby

require 'json'
require 'erb'

# 
# GET COLUMNS NAMED RIGHT
# 

def fields
  # Parses column names
  columns = JSON.parse(File.read("column_names.json"))
  # Keep track of which fields have transform entries
  fields = columns.select { |k,v| v != "null" }
end

def load
  # Parses projects from export
  projects = JSON.parse(File.read('export.json'))
  projects = projects['rows']

  # Renames the columns if they are kept
  projects = projects.map  do |i| 
    output = {}
    i.each { |k,v| output[fields[k]] = v if fields.include? k }
    output
  end
end

#
# CLEAN EACH PROJECT
# 

def clean(projects)
  projects = projects.map do |project|

    project.each do |_, val| 
      # No nulls please
      val = '' unless val
      # Remove colons, tabs and newlines
      val.gsub! /:/, ''
      val.gsub! /\t/, ' '
      val.gsub! /\n/, ' '
    end

  end

  projects = projects.reject do |project|
    split_fields = %w{country partner_type}
    project.any? {|k,v| split_fields.include? k and v == nil}
  end

  projects
end

# 
# TEMPLATE EACH PROJECT
# 

# Init the template
def template(projects)
  tmpl = ERB.new(File.read('../lib/project_file_template.erb'))

  project_count = 1

  projects.each do |project|
    project["open_project_id"] = 1 
    project["id"] = project_count.to_s.rjust(8, "0")

    project_count += 1

    project = OpenStruct.new(project)

    # Bind to this scope (includes the `project` object)
    b = binding
    begin
      # Try to template the project
      output = tmpl.result b
    rescue Exception => e
      # Mostly have problems with missing attributes that aren't
      # removed by the cleaning stage
      puts project, e
      break
    end
    # puts project.id
    File.open(File.join('../../_ssc_projects',project.id) + '.txt', 'w') do |file|
      file.write(output)
    end
  end
end

projects = load
projects = clean(projects)
template(projects)
