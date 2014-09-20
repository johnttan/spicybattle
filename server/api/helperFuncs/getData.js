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
  var tegID = body.tegID;
  var authID = body.authID;
  var playerName = body.playerName;

  var url = "http://www.cartoonnetwork.com/champions-papi/v2/user/champions?TEGid="+tegID+"&authid=" + authID;
  var beforeRequestTime = new Date();
  request(url, function(error, response, body){
    if (error){res.send(400);return console.log('error requesting data', error)};
    
    var data = JSON.parse(body);
    if(verify(data, playerName)){
      // console.log(data);
      data.inventory = data.data.inventory;
      data.profile = data.data.profile;
      data.playerName = data.profile.playerName;
      delete(data.data);
      var updateQuery = {
        $set: data,
        $addToSet:{'gameLog': {$each: data.profile.gameLog}}
      };
      var gameLog = data.profile.gameLog;
      delete data.profile.gameLog;
      var time1 = new Date();
      console.log(time1 - beforeRequestTime, 'requestTime', data.playerName)
      Data.findOneAndUpdate({'playerName': data.playerName}, updateQuery, {'new':true}, function(err, retdata){
        if(!retdata){
          data.gameLog = gameLog;
          Data.findOneAndUpdate({'playerName': data.playerName}, data, {upsert:true, 'new':true}, function(err, retdata){
            if(err){return console.log(err)}
            var time2 = new Date();
            console.log(time2 - time1, 'newPlayerTime', data.playerName);
            if(res && !cb){
              res.json(retdata)
            }
            if(cb){
              cb(retdata)
            }
          })
        }else{
          var time2 = new Date();
          console.log(time2 - time1, 'existingPlayerTime', data.playerName);

          if(res && !cb){
            res.json(retdata)
          }
          if(cb){
            cb(retdata)
          }
          }
      })
    }else{
      console.log('malformed data', data, playerName)
      res.send(400)
    }
  })
}