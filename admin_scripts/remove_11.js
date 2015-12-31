// Move the content from the mysterious "11" keys from mutliple projects, and place in the main body of the project files

var fs = require('fs'),
    path = require('path'),
    _ = require('lodash');

ROOT = '../_ssc_projects/';
ELEVEN_REGEX = /---\n\"11\":\s\"?(.*)\"?$/m;
DEFAULT_TEXT_REGEX = /---\n{2,4}## A New Post\n\nEnter text in \[Markdown]\(http:\/\/daringfireball\.net\/projects\/markdown\/\)\. Use the toolbar above, or click the \*\*\?\*\* button for formatting help\./gm;

function project_files(){
  return _.reject(fs.readdirSync(ROOT), function(entry){
    return entry === '.DS_Store';
  });
}

function broken_files(){
  return _.select(project_files(), function(file){
    var content = project_content_from(file);
    return has_eleven(content) && has_default_content(content);
  })
}

function project_content_from(file){
  var path = ROOT + file;
  return fs.readFileSync(ROOT + file, 'utf8');
}

function fixed_content(file){
  // Only receiving projects with '11' and unchanged default body content
  
  // var data = project_data_from(file);
  // data.body = data.attributes['11'];
  // delete data.attributes['11'];
  // return data;
}

function is_broken(content){
  return has_eleven(content) && has_default_content(content);
}

function has_eleven(content) {
  return (ELEVEN_REGEX.exec(content) !== null);
}

function has_default_content(content) {
  return (DEFAULT_TEXT_REGEX.exec(content) !== null);
}

function create_text_file(data){
  var output = "---\n";

}


function move_11(content){
  
}

function set_published(content){
  
}

function process_all(){
  // Get all broken files
  // Check 
}




