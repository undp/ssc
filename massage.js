// a = [array of PROJECT objects]

// // Location to locations array
// b = _.map(a, function(i) {i.locations = split3(i.location); return i; })
// function split3(term) { return term.match(/\w{1,3}/g) }

// // One way to filter by individual location
// _.select(b, function(i){return _.include(i.locations, 'ARE') })

// Id from filename
// match(/_ssc_data\/(.{1,20})\.txt/)