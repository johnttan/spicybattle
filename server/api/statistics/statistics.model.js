'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var StatisticsSchema = new Schema({
  name: {type: String, index:true},
  data: Object,
  placementTable: Object
});

module.exports = mongoose.model('Statistics', StatisticsSchema);