var rateLimiter = function(timeDiff, maxPlayersQueue){
  this.playerTable = {};
  this.playerQueue = [];
  this.timeDiff = timeDiff;
  this.maxPlayersQueue = maxPlayersQueue;
  console.log('init', 'timediff', timeDiff, 'maxplayersqueue', maxPlayersQueue);
  return this
}
// Possibly use heap for smarter queue removal?
rateLimiter.prototype.checkPlayer = function(playerName){
  var go = false;
  if(!(playerName in this.playerTable)){
    this.playerTable[playerName] = {
      time: new Date()
    };
    this.playerQueue.push(playerName);
    go = true
  }else{
    var current = new Date();
    var timeDiff = current - this.playerTable[playerName].time;
    if(timeDiff > this.timeDiff){
      this.playerTable[playerName].time = current;
      go = true
    }
  }

  if(this.playerQueue.length > this.maxPlayersQueue){
    // O(n) operation. Can be brutal to speed.

    var removedPlayer = this.playerQueue.shift();
    delete this.playerTable[removedPlayer]
  }
  if(!go){
    console.log(playerName, 'reached rate limit', 'timediff', timeDiff);
  }
  return go
}

exports.rateLimiter = rateLimiter
