'use strict';

var _ = require('lodash');
var Data = require('./data.model');
var Authid = require('../authID/authID.model');
var getData = require('../helperFuncs/getData.js').func

// Get list of datas
// exports.index = function(req, res) {
//   Data.find(function (err, datas) {
//     if(err) { return handleError(res, err); }
//     return res.json(200, datas);
//   });
// };

// Get a single data
exports.show = function(req, res) {
  // Name is separated by "." in the REST URL
  var playerName = req.params.playerName.split('.').join(' ').toUpperCase()
  console.log(playerName)
  Data.findOne({'profile.playerName':playerName}, function (err, data) {
    if(err) { return handleError(res, err); }
    if(!data) { return res.send(404); }
    return res.json(data);
  });
};

// // Creates a new data in the DB.
// exports.create = function(req, res) {
//   // console.log(req.body);
//   Authid.update({'authID': req.body.authID}, req.body, {'upsert': true}, function(err, numAffected){
//     if(err){console.log(err)}
//     else{
//       getData(req.tegID, req.authID);
//     }
//   })
// };

// Updates an existing data in the DB.
exports.update = function(req, res) {
  var playerName = req.params.playerName.split('.').join(' ').toUpperCase();
  Authid.find({'playerName':playerName}, function (err, data) {
    if(err){return console.log(err)}
    console.log('update', data)
    getData(data[0], res);
  });
};


function handleError(res, err) {
  return res.send(500, err);
}