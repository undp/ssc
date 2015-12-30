// Move the content from the mysterious "11" keys from mutliple projects, and place in the main body of the project files

var fs = require('fs'),
    path = require('path'),
    fm = require('front-matter'),
    _ = require('lodash');

ROOT = '../_ssc_projects/';

function project_files(){
  return _.reject(fs.readdirSync(ROOT), function(entry){
    return entry === '.DS_Store';
  });
}

function broken_files(){
  return _.select(project_files(), function(file){
    var keys = _.keys(project_data_from(file).attributes);
    return _.includes(keys, "11");
  })
}

function project_data_from(file){
  var path = ROOT + file;
  var data = fs.readFileSync(ROOT + file, 'utf8')
  return fm(data);
}

// console.log(project_data_from(broken_files()[0]));
// console.log(project_files().length)
console.log(broken_files().length)