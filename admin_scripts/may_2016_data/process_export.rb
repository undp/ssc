require 'json'
require 'erb'

# 
# GET COLUMNS NAMED RIGHT
# 

# Parses column names
columns = JSON.parse(File.read("column_names.json"))
# Keep track of which fields have transform entries
fields = columns.select { |k,v| v != "null" }

# Parses projects from export
projects = JSON.parse(File.read('export.json'))
projects = projects['rows'][0..2]

# Renames the columns if they are kept
projects = projects.map  do |i| 
  output = {}
  i.each { |k,v| output[fields[k]] = v if fields.include? k }
  output
end

# 
# TEMPLATE EACH PROJECT
# 

# Init the template
tmpl = ERB.new(File.read('../lib/project_file_template.erb'))
project_count = 1


projects.each do |project|
  project["open_project_id"] = 1 # Add missing attribute
  project["id"] = project_count.to_s.rjust(5, "0")

  project_count += 1

  project = OpenStruct.new(project)
  # Bind to this scope (includes the `project` object)
  b = binding
  output = tmpl.result b
  # puts project.id
  File.open(File.join('test_output',project.id), 'w') do |file|
    file.write(output)
  end
end

