'use strict';

var _ = require('lodash');
var Statistics = require('./statistics.model');

// Get list of statisticss
exports.index = function(req, res) {
  Statistics.find(function (err, statisticss) {
    if(err) { return handleError(res, err); }
    return res.json(200, statisticss);
  });
};

// Get a single statistics
exports.show = function(req, res) {
  Statistics.findById(req.params.id, function (err, statistics) {
    if(err) { return handleError(res, err); }
    if(!statistics) { return res.send(404); }
    return res.json(statistics);
  });
};

// Creates a new statistics in the DB.
exports.create = function(req, res) {
  Statistics.create(req.body, function(err, statistics) {
    if(err) { return handleError(res, err); }
    return res.json(201, statistics);
  });
};

// Updates an existing statistics in the DB.
exports.update = function(req, res) {
  if(req.body._id) { delete req.body._id; }
  Statistics.findById(req.params.id, function (err, statistics) {
    if (err) { return handleError(res, err); }
    if(!statistics) { return res.send(404); }
    var updated = _.merge(statistics, req.body);
    updated.save(function (err) {
      if (err) { return handleError(res, err); }
      return res.json(200, statistics);
    });
  });
};

// Deletes a statistics from the DB.
exports.destroy = function(req, res) {
  Statistics.findById(req.params.id, function (err, statistics) {
    if(err) { return handleError(res, err); }
    if(!statistics) { return res.send(404); }
    statistics.remove(function(err) {
      if(err) { return handleError(res, err); }
      return res.send(204);
    });
  });
};

function handleError(res, err) {
  return res.send(500, err);
}