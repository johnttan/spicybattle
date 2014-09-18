'use strict';

var _ = require('lodash');
var Data = require('./data.model');
var Authid = require('../authID/authID.model');
var getData = require('../helperFuncs/getData.js').func

// Get list of datas
exports.index = function(req, res) {
  Data.find(function (err, datas) {
    if(err) { return handleError(res, err); }
    return res.json(200, datas);
  });
};

// Get a single data
exports.show = function(req, res) {
  // Name is separated by "." in the REST URL
  var playerName = req.params.playerName.split('.').join(' ').toUpperCase()
  console.log(playerName)
  Data.findOne({'playerName':playerName}, function (err, data) {
    if(err) { return handleError(res, err); }
    if(!data) { return res.send(404); }
    return res.json(data);
  });
};

// Updates an existing data in the DB.
exports.update = function(req, res) {
  var playerName = req.params.playerName.split('.').join(' ').toUpperCase();
  Authid.find({'playerName':playerName}, function (err, data) {
    if(err){return console.log(err)}
    if(data[0]){
      console.log('update', data[0].playerName)
      getData(data[0], res);
    }else{
      res.send(404);
    }
  });
};


function handleError(res, err) {
  return res.send(500, err);
}