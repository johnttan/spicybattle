'use strict';

var _ = require('lodash');
var Authid = require('./authID.model');
var getData = require('../helperFuncs/getData.js').func

// Returns a callback for getData. This callback updates the authID in database only if getData gets a valid playerData.
function cb(tegID, body, res){
  return function(){
    Authid.update({'tegID': tegID}, body, {'upsert': true}, function(err, numAffected){
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
    getData(req.body, res, cb(req.body.tegID, req.body, res));
  }else{
    console.log('error', req.body);
    res.send(400)
  }
};

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