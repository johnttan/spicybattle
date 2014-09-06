var request = require('request');
var Data = require('../data/data.model');
// Retrieves user data from CN servers, updates database, and returns data in response.
exports.func = function(tegID, authID, res){
  var url = "http://www.cartoonnetwork.com/champions-papi/v2/user/champions?TEGid="+tegID+"&authid=" + authID;
  console.log(tegID, authID, url)
  request(url, function(error, response, body){
    if (error){return console.log('error', error)};
    if(body){
      var data = JSON.parse(body);
      // console.log(data);
      data.inventory = data.data.inventory;
      data.profile = data.data.profile;
      delete(data.data);
      Data.update({'profile.playerName': data.profile.playerName}, data, {'upsert': true}, function(err, numAffected){
        if(err){console.log(err)}
      })
      if(res){
        res.json(data)
      }
    }
  })
}