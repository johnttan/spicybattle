mongoose = require('mongoose')
process.env.NODE_ENV = process.env.NODE_ENV || 'development'
config = require('../server/config/environment')
mongoose.connect(config.mongo.uri, config.mongo.options)
Data = require('../server/api/data/data.model')
Statistics = require('../server/api/statistics/statistics.model')
_ = require('lodash')

mapReduce = 
  do(Data=Data)->
    map = (doc)->
      if doc.gameLog
        doc.gameLog.sort((a, b)->
          aDate = new Date(a._date)
          bDate = new Date(b._date)
          # Descending order. Earliest first.
          return bDate.getTime() - aDate.getTime()
          )
        newGameLog = doc.gameLog.slice(0, 100)
        Data.update({'playerName':doc.playerName}, {'gameLog':newGameLog}, (err, num)->
            console.log('finished processing matches for', doc.playerName)
          )
      else
        console.log 'no gameLog', doc
    return map
stream = Data.find().stream()
stream.on('data', mapReduce)
stream.on('error', ->
  console.log 'error processing cullMatches'
  )
stream.on('close', ->
  console.log 'finished sending out updates for cullMatches'
)