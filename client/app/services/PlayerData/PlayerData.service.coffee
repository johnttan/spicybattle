'use strict'

angular.module 'spicyPartyApp'
.service 'PlayerData', ['$http', 'Recent', 'ProfileStats'
    class PlayerData
      constructor: ($http, Recent, ProfileStats)->
        @http = $http
        @getStats = ProfileStats.getStats
        @checkRecent = Recent.checkRecent
        @addRecent = Recent.addRecent
        @playerData = {}
        @recentSearches = Recent.getRecent()
        @stats = {}
      convertName: (playerName, decode)->
        if decode
          return playerName.split('.').join(' ')
        else
          return playerName.split(' ').join('.').toUpperCase()
      loadData: (playerData)=>
        @playerData = playerData
        @profile = playerData.profile
        @gameLog = playerData.gameLog
        @playerName = @convertName(playerData.profile.playerName)
        @recentSearches = @addRecent(@playerName, playerData)
        @stats = @getStats(playerData.gameLog)
      searchPlayer: (playerName, error)=>
        @profile = {}
        @gameLog = []
        @playerData = {}
        boundFunc = do(pdata=@, error=error, playerName=playerName)->
          ->
            pdata.searchPlayer(playerName, pdata.loadData, error)
        playerCache = @checkRecent(playerName, boundFunc)
        if playerCache
          console.log('cache found')
          @loadData(playerCache)
        else
          @http.get("/api/data/" + playerName).success(@loadData).error(error)
]