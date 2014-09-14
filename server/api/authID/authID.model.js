'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var AuthidSchema = new Schema({
  tegID: {type:String, index:true},
  authID: String,
  playerName: {type:String, index:true}
});

module.exports = mongoose.model('Authid', AuthidSchema);