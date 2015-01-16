// https://gist.github.com/mbostock/1696080
util.request = function(url, callback) {
  var req = new XMLHttpRequest;
  req.open("GET", url, true);
  // req.setRequestHeader("Accept", "application/json");
  req.onreadystatechange = function() {
    if (req.readyState === 4) {
      if (req.status < 300) callback(null, JSON.parse(req.responseText));
      else callback(req.status);
    }
  };
  req.send(null);
}

