'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var DataSchema = new Schema({
	"userId": String,
	"modifiedDate": Number,
	"inventory": Array,
	"profile": Object,
  "playerName": {type:String, index: true},
  "gameLog": Array,
  "lastUpdated": String
});

module.exports = mongoose.model('Data', DataSchema);