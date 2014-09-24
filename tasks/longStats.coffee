mongoose = require('mongoose')
process.env.NODE_ENV = process.env.NODE_ENV || 'development'
config = require('../server/config/environment')
Data = require('../server/api/data/data.model')
Statistics = require('../server/api/statistics/statistics.model')
mongoose.connect(config.mongo.uri, config.mongo.options)
ProfileClass = require('./ProfileHelpers').profileClass
ProfileHelper = new ProfileClass
lodash = require('lodash')

globalStats = {}
mapReduce = 
    do(getStats=ProfileHelper.getStats, globalStats=globalStats, lodash=lodash)->
      map = (data)->
        console.log data.playerName
        stats = getStats(data.gameLog)
        if 'champStats' not of globalStats
          lodash.merge(globalStats, stats)
        else
          lodash.each(stats.champStats, (val, champ)->
            lodash.each(val, (value, stat)->
              if stat isnt 'belts'
                if champ not of globalStats.champStats
                  globalStats.champStats[champ] = {}
                if stat not of globalStats.champStats[champ]
                  globalStats.champStats[champ][stat] = 0
                globalStats.champStats[champ][stat] += value
              )
          )
          lodash.each(stats.packStats, (val, key)->
            lodash.each(val, (num, result)->
              if key not of globalStats.packStats
                globalStats.packStats[key] = {}
              if result not of globalStats.packStats[key]
                globalStats.packStats[key][result] = 0 
              globalStats.packStats[key][result] += num
              )
          )
          globalStats.gamesAnalyzed += stats.gamesAnalyzed

      return map
startTime = new Date()
stream = Data.find().stream()
stream.on('data', mapReduce)
stream.on('error', ->
  console.log 'error processing stats'
  )
stream.on('close', 
  do(globalStats=globalStats)->
    ->
      console.log 'done processing stats'
      Statistics.update({name: 'globalstats'}, {name: 'globalstats', data:globalStats}, {upsert:true}, (err, numAffected)->
        endTime = new Date()
        console.log endTime - startTime, 'time spent globalstats'
        if err or numAffected < 1
          console.log err, numAffected, 'updating globalStats'
        process.exit()
      )
  )
