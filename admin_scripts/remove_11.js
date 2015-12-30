// Move the content from the mysterious "11" keys from mutliple projects, and place in the main body of the project files

var fs = require('fs'),
    path = require('path'),
    fm = require('front-matter'),
    _ = require('lodash');

ROOT = '../_ssc_projects/';
DEFAULT_TEXT = "\n\n\n## A New Post\n\nEnter text in [Markdown](http://daringfireball.net/projects/markdown/). Use the toolbar above, or click the **?** button for formatting help.\n'"

function project_files(){
  return _.reject(fs.readdirSync(ROOT), function(entry){
    return entry === '.DS_Store';
  });
}

function broken_files(){
  return _.select(project_files(), function(file){
    var data = project_data_from(file);
    return has_eleven(data.attributes) && default_content(data.body);
  })
}

function project_data_from(file){
  var path = ROOT + file;
  var data = fs.readFileSync(ROOT + file, 'utf8')
  return fm(data);
}

function fixed_content(file){
  // Only receiving projects with '11' and unchanged default body content
  var data = project_data_from(file);
  data.body = data.attributes['11'];
  delete data.attributes['11'];
  return data;
}

function default_content(body) {
  return true
  return body === DEFAULT_TEXT;
}

function has_eleven(attributes) {
  var keys = _.keys(attributes);
  return _.includes(keys, "11");
}

function create_text_file(data){
  var output = "---\n";

}

function stringify_attributes(attributes){
  var string = "";
  return _.each(attributes, function (key, value) {
  })
}

function process_all(){
  // Get all broken files
  // Check 
}



// console.log(project_data_from(broken_files()[0]));
// console.log(project_files().length)
// console.log(broken_files().length)
console.log(fixed_content('xxxc7fbab17.txt'))
content = fixed_content('xxxc7fbab17.txt');
// console.log(project_data_from('xxxc7fbab17.txt'))
fs.writeFileSync('test_output.txt', JSON.stringify(content));