'use strict'

angular.module 'spicyPartyApp'
.service 'Statistics', ['$http',
  class Statistics
    constructor: ($http)->
      @http = $http
      @leaders = []
      @globalStats = {}
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

]