'use strict';

var _ = require('lodash');
var Statistics = require('./statistics.model');

var cache = {};

// Get a single statistics
exports.show = function(req, res) {
  var id = req.params.id.toLowerCase();
  var now = (new Date()).getTime();
  if (cache[id] && (now - cache[id].time) < 300000) {
    return res.json(cache[id].data)
  }
  Statistics.findOne({name:id}, function (err, statistics) {
    if(err) { return handleError(res, err); }
    if(!statistics) { return res.send(404); }
    cache[id] = {
      time: (new Date()).getTime(),
      data: statistics
    };
    return res.json(statistics);
  });
};


function handleError(res, err) {
  return res.send(500, err);
}
