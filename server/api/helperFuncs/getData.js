var request = require('request');
var Data = require('../data/data.model');
// Verifies validity of returned json.
function verify(data, playerName){
  if(!data.data){console.log('nodata', data);return false};
  if(!data.data.profile){console.log('noprofile', data);return false};
  if(data.data.profile.playerName !== playerName){console.log('playerName incorrect', data);return false};
  return true
}
exports.verify = verify
// Retrieves user data from CN servers, updates database, and returns data in response.
exports.func = function(body, res, cb){
  tegID = body.tegID;
  authID = body.authID;
  playerName = body.playerName;

  var url = "http://www.cartoonnetwork.com/champions-papi/v2/user/champions?TEGid="+tegID+"&authid=" + authID;
  request(url, function(error, response, body){
    if (error){res.send(400);return console.log('error requesting data', error)};
    
    var data = JSON.parse(body);
    if(verify(data, playerName)){
      // console.log(data);
      data.inventory = data.data.inventory;
      data.profile = data.data.profile;
      data.playerName = data.profile.playerName;
      delete(data.data);
      Data.update({'playerName': data.playerName}, data, {'upsert': true}, function(err, numAffected){
        if(err){console.log(err)}
      })
      if(res && !cb){
        res.json(data)
      }
      if(cb){
        cb(data)
      }
    }else{
      console.log('malformed data', data, playerName)
      res.send(400)
    }
  })
}