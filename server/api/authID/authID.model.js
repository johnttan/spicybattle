'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var AuthidSchema = new Schema({
  tegID: String,
  authID: String,
  playerName: String
});

module.exports = mongoose.model('Authid', AuthidSchema);