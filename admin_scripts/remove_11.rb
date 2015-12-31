# Load all _ssc_projects
# Check each for an "11" key
# If true
#   body = content["11"]
#   content.delete["11"]
#   reconstruct and write_file
# print out some progress

require 'yaml'

ROOT_DIR = "../_ssc_projects"
YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m

def project_filenames
  Dir.entries(ROOT_DIR).reject do |filename|
    %w{. .. .DS_Store}.include? filename
  end
end

def load_content(filename)
  content = File.read(File.join(ROOT_DIR, filename))

  if content =~ YAML_FRONT_MATTER_REGEXP
    body = $'
    data = YAML.load($1)
    {body: body, data: data}
  end
end

def broken_content(content)
  data = content[:data]
  data.keys.include? "11"
end

def fix_content(content)
  body = content[:data]["11"]
  content[:data].delete "11"
  data = content[:data]
  {body: body, data: data}
end

def write_file(filename, content)
  content = fix_content(content)
  File.open('output.txt', 'w') do |file|
    file << "---"
    file << YAML.dump(content[:data])
    file << "---\n"
    file << content[:body]
  end
end

def process_all
  # get all files
  # for each
  project_filenames.each do |filename|
    content = load_content(filename)
    # check if broken
    if broken_content(content)
      # puts "Need to fix #{filename}"
      fixed_content = fix_content(content)
      puts "Fixed #{filename}", fixed_content
    end
  end
  #   if broken, fix
  #   write
  #   log/mark progress
end

# data = load_content("00045776.txt")[:data]
# content = load_content("xxx742ba697.txt")
# data = content[:data]
# puts broken_content(content)
# write_file(nil, content)
process_all