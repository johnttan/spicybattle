mongoose = require('mongoose')
process.env.NODE_ENV = process.env.NODE_ENV || 'development'
config = require('../server/config/environment')
mongoose.connect(config.mongo.uri, config.mongo.options)
Data = require('../server/api/data/data.model')
Statistics = require('../server/api/statistics/statistics.model')
_ = require('lodash')

allData = []

mapReduce = 
  do(_=_, allData=allData)->
    (data)->
      if data.gameLog
        _.each(data.gameLog, (game)->
          difference = 0
          if parseInt(game.elo) > 0
            difference = game.winTeamElo - game.loseTeamElo
          else
            difference = game.loseTeamElo - game.winTeamElo
          dataPoint = {
            delta: difference
            eloGain: game.elo
          }
          allData.push(dataPoint)
        )

stream = Data.find().stream()
stream.on('data', mapReduce)
stream.on('error', ->
  console.log 'error processing stats'
  )
stream.on('close',
  do(allData=allData)->
    ->
      Statistics.update({name: 'elostats'}, {name: 'elostats', data:allData}, {upsert:true}, (err, numAffected)->
        console.log 'finished updating elostats'
        process.exit()
      )

)