mongoose = require('mongoose')
process.env.NODE_ENV = process.env.NODE_ENV || 'development'
config = require('../server/config/environment')
Data = require('../server/api/data/data.model')
Statistics = require('../server/api/statistics/statistics.model')
mongoose.connect(config.mongo.uri, config.mongo.options)

Data.update({'profile.token':{'$exists':true}}, {'$unset':{'profile.token':true}}, {'multi':true}, ->
  process.exit()
)
