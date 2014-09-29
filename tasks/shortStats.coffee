mongoose = require('mongoose')
process.env.NODE_ENV = process.env.NODE_ENV || 'development'
config = require('../server/config/environment')
Data = require('../server/api/data/data.model')
Statistics = require('../server/api/statistics/statistics.model')
mongoose.connect(config.mongo.uri, config.mongo.options)
_ = require('lodash')

# Should limit to 1800 elo and above on release.
updateEloLeaderboards = (previousTable)->
  console.log previousTable
  eloArray = []
  processElo = 
    do(eloArray=eloArray)->
      map = (data)->
        if data
          playerData = {
            playerName: data.playerName
            elo: data.profile.elo
            winRate: (data.profile.winsPVP / data.profile.playsPVP) * 100
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
    do(eloArray=eloArray, Statistics=Statistics, startTime=startTime, previousTable=previousTable, _=_)->
      ->
        eloArray.sort((a, b)->
          if b.elo is a.elo
            console.log 'same elo', b.playerName, b.elo, a.playerName, a.elo
            console.log b.winRate, a.winRate, b.winRate - a.winRate
            return b.winRate - a.winRate
          return b.elo - a.elo
        )
        _.each(eloArray, (player, ind)->
          player.delta = previousTable[player.playerName] - ind 
        )
        if previousTable.increment
          previousTable.increment = previousTable.increment + 1
        else
          previousTable.increment = 1
        doc = {
          name: 'eloleaderboard'
          data: eloArray
          placementTable: previousTable
        }
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


Statistics.findOne({name: 'eloleaderboard'}, (err, doc)->
  if not doc.placementTable or doc.placementTable.increment >= 444
    placementTable = {}
    _.each(doc.data, (player, ind)->
      placementTable[player.playerName] = ind
    )
    placementTable.increment = 1
  else
    placementTable = doc.placementTable
  updateEloLeaderboards(placementTable)

)