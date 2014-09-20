mongoose = require('mongoose')
process.env.NODE_ENV = process.env.NODE_ENV || 'development'
config = require('../server/config/environment')
Data = require('../server/api/data/data.model')
Statistics = require('../server/api/statistics/statistics.model')
mongoose.connect(config.mongo.uri, config.mongo.options)


updateEloLeaderboards = ->
  Data.find({}, 'playerName profile.elo').sort('-profile.elo').exec((err, docs)->
    docslimited = JSON.parse(JSON.stringify(docs.splice(0, 50)))
    doc = {
      name: 'eloleaderboard'
      data: docslimited
    }
    Statistics.update({name: 'eloleaderboard'}, doc, {upsert:true}, (err)->
        if err
          console.log err
        else
          console.log 'done updating eloleaderboard'
    )
  )

updateEloLeaderboards()