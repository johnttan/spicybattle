mongoose = require('mongoose')
process.env.NODE_ENV = process.env.NODE_ENV || 'development'
config = require('../server/config/environment')
Data = require('../server/api/data/data.model')
Statistics = require('../server/api/statistics/statistics.model')
mongoose.connect(config.mongo.uri, config.mongo.options)

# Should limit to 1800 elo and above on release.
updateEloLeaderboards = ->
  eloArray = []
  processElo = 
    do(eloArray=eloArray)->
      map = (data)->
        if data
          playerData = {
            playerName: data.playerName
            elo: data.profile.elo
          }
          eloArray.push(playerData)
      return map
  startTime = new Date()
  stream = Data.find().stream()
  stream.on('data', processElo)
  stream.on('error', ->
    console.log 'error processing leaderboard'
  )
  stream.on('close', 
    do(eloArray=eloArray, Statistics=Statistics, startTime=startTime)->
      ->
        eloArray.sort((a, b)->
          return b.elo - a.elo
        )
        doc = {
          name: 'eloleaderboard'
          data: eloArray
        }
        console.log eloArray, doc
        Statistics.update({name: 'eloleaderboard'}, doc, {upsert:true}, (err)->
          if err
            console.log err
            console.log 'error in ' + (endTime - startTime).toString()
            endTime = new Date()
            process.exit()
          else
            endTime = new Date()
            console.log 'done updating eloleaderboard in ' + (endTime - startTime).toString()
            process.exit()
        )
  )

updateEloLeaderboards()