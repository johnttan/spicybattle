mongoose = require('mongoose')
process.env.NODE_ENV = process.env.NODE_ENV || 'development'
config = require('../server/config/environment')
mongoose.connect(config.mongo.uri, config.mongo.options)
Data = require('../server/api/data/data.model')
Statistics = require('../server/api/statistics/statistics.model')
_ = require('lodash')


Data.where()
  .setOptions({multi: true})
  .update(
    {
      $push: {
        gameLog: {
          $each: []
          $sort: {
            '_date': 1
          }
          $slice: -100
        }
      }
    },
    (err, num)->
      console.log err, num
  )