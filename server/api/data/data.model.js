'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var DataSchema = new Schema({
	"userId": String,
	"modifiedDate": Number,
	"inventory": Array,
	"profile": Object
});

module.exports = mongoose.model('Data', DataSchema);