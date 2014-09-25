'use strict';

var _ = require('lodash');
var Statistics = require('./statistics.model');

// Get a single statistics
exports.show = function(req, res) {
  Statistics.findOne({name:req.params.id.toLowerCase()}, function (err, statistics) {
    if(err) { return handleError(res, err); }
    if(!statistics) { return res.send(404); }
    return res.json(statistics);
  });
};


function handleError(res, err) {
  return res.send(500, err);
}