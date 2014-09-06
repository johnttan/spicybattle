'use strict';

var _ = require('lodash');
var Authid = require('./authID.model');
var getData = require('../helperFuncs/getData.js').func
// Get list of authIDs
exports.index = function(req, res) {
  Authid.find(function (err, authIDs) {
    if(err) { return handleError(res, err); }
    return res.json(200, authIDs);
  });
};

// Get a single authID
exports.show = function(req, res) {
  Authid.findById(req.params.id, function (err, authID) {
    if(err) { return handleError(res, err); }
    if(!authID) { return res.send(404); }
    return res.json(authID);
  });
};

// Creates a new authID in the DB.
exports.create = function(req, res) {
  req.body.playerName = req.body.playerName.toUpperCase()
  Authid.update({'authID': req.body.authID}, req.body, {'upsert': true}, function(err, numAffected){
    if(err){console.log(err)}
    else{
      getData(req.body.tegID, req.body.authID);
      res.send(200);
    }
  })
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