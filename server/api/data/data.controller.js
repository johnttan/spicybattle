'use strict';

var _ = require('lodash');
var Data = require('./data.model');
var Authid = require('../authID/authID.model');
var getData = require('../helperFuncs/getData.js').func

// Updates an existing data in the DB.
function update(req, res) {
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

// Get a single data
exports.show = function(req, res) {
  // Name is separated by "." in the REST URL
  var playerName = req.params.playerName.split('.').join(' ').toUpperCase()
  console.log(playerName)
  Data.findOne({'playerName':playerName}, function (err, data) {
    if(err) { return handleError(res, err); }
    if(!data) { return res.send(404); }
    var now = new Date().getTime();
    if(now - data.modifiedDate > 800000){
      console.log('updating ' + playerName + ' because outdated');
      update(req, res);
    }else{
      return res.json(data);
    }
  });
};



function handleError(res, err) {
  return res.send(500, err);
}