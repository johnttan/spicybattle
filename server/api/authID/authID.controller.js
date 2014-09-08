'use strict';

var _ = require('lodash');
var Authid = require('./authID.model');
var getData = require('../helperFuncs/getData.js').func
// Get list of authIDs
// exports.index = function(req, res) {
//   Authid.find(function (err, authIDs) {
//     if(err) { return handleError(res, err); }
//     return res.json(200, authIDs);
//   });
// };

// Get a single authID
// exports.show = function(req, res) {
//   Authid.findById(req.params.id, function (err, authID) {
//     if(err) { return handleError(res, err); }
//     if(!authID) { return res.send(404); }
//     return res.json(authID);
//   });
// };
// Returns a callback for getData. This callback updates the authID in database only if getData gets a valid playerData.
function cb(authID, body, res){
  return function(){
    Authid.update({'authID': authID}, body, {'upsert': true}, function(err, numAffected){
      console.log('updatedID for ' + body.playerName)
      if(err){console.log(err)}
      else{
        res.send(200);
      }
    })
  }
}
// Creates a new authID in the DB.
exports.create = function(req, res) {
  if((typeof req.body.playerName) == 'string' && (typeof req.body.authID) == 'string' && (typeof req.body.tegID) == 'string'){
    req.body.playerName = req.body.playerName.toUpperCase()
    getData(req.body, res, cb(req.body.authID, req.body, res));
  }else{
    console.log('error', req.body);
    res.send(400)
  }
};

// Updates an existing authID in the DB.
// exports.update = function(req, res) {
//   if(req.body._id) { delete req.body._id; }
//   Authid.findById(req.params.id, function (err, authID) {
//     if (err) { return handleError(res, err); }
//     if(!authID) { return res.send(404); }
//     var updated = _.merge(authID, req.body);
//     updated.save(function (err) {
//       if (err) { return handleError(res, err); }
//       return res.json(200, authID);
//     });
//   });
// };

// // Deletes a authID from the DB.
// exports.destroy = function(req, res) {
//   Authid.findById(req.params.id, function (err, authID) {
//     if(err) { return handleError(res, err); }
//     if(!authID) { return res.send(404); }
//     authID.remove(function(err) {
//       if(err) { return handleError(res, err); }
//       return res.send(204);
//     });
//   });
// };

function handleError(res, err) {
  return res.send(500, err);
}