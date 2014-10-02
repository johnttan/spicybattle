'use strict'

angular.module 'spicyPartyApp'
.service 'Statistics', ['$http',
  class Statistics
    constructor: ($http)->
      @http = $http
      @leaders = []
      @globalStats = {}
      @eloStats = []
    loadLeaders: (data)=>
      console.log "loaded leaderboard"
      @leaders = data.data
    loadStats: (data)=>
      console.log "loaded stats"
      @globalStats.champStats = _.map(data.data.champStats, (el, key)->
        return {
          name: key
          stats: el
        }
      )
      @globalStats.packStats = _.map(data.data.packStats, (el, key)->
        return {
          name: key
          stats: el
        }
      )
      @globalStats.gamesAnalyzed = data.data.gamesAnalyzed
    loadEloStats: (data)=>
      winners = {
        key: 'Wins'
        color: '#0049BD'
        values: []
      }
      losers = {
        key: 'Losses'
        color: '#F3005D'
        values: []
      }
      _.each(data.data, (dataPoint)->
        dataPoint.x = dataPoint.delta
        dataPoint.y = dataPoint.eloGain
        delete dataPoint.delta
        delete dataPoint.eloGain
        if parseInt(dataPoint.y) > 0
          winners.values.push(dataPoint)
        else if parseInt(dataPoint.y) < 0
          losers.values.push(dataPoint)
      )
      @eloStats = [winners, losers]
      console.log 'loaded elostats'
    getEloLeaderboard: =>
      @http.get('/api/statistics/eloleaderboard')
        .success(@loadLeaders)
        .error((error)->
          console.log(error)
        )
    getGlobalStats: =>
      @http.get('/api/statistics/globalstats')
        .success(@loadStats)
        .error((error)->
          console.log(error)
        )
    getEloStats: ($scope)=>
      console.log 'getting elo report'
      @scope = $scope
      @http.get('/api/statistics/elostats')
        .success(@loadEloStats)
        .error((error)->
          console.log(error)
        )
]