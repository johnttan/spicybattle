'use strict';

var _ = require('lodash');
var Data = require('./data.model');
var Authid = require('../authID/authID.model');
var getData = require('../helperFuncs/getData.js').func
var rateLimiter = require('../helperFuncs/rateLimitPlayers.js').rateLimiter
// Rate limit to once every 10 seconds for updates per player. 1000 players in rate table.
rateLimiter = new rateLimiter(10000, 1000);
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
  console.log('getData from', req.ip)
  // Name is separated by "." in the REST URL
  var playerName = req.params.playerName.split('.').join(' ').toUpperCase()
  Data.findOne({'playerName':playerName}, function (err, data) {
    if(err) { return handleError(res, err); }
    if(!data) { return res.send(404); }
    var now = new Date().getTime();
    // Rate limits update calls per player. Prevents unnecessary HTTP calls to CN servers and DB update operations.
    if(now - data.modifiedDate > 600000 && rateLimiter.checkPlayer(data.playerName)){
      console.log('updating ' + playerName + ' because outdated');
      update(req, res);
    }else{
      // If last game is too soon, or rate limit reached, return the document without expensive update operations.
      delete data.profile.token
      return res.json(data);
    }
  });
};



function handleError(res, err) {
  return res.send(500, err);
}