'use strict'

angular.module 'spicyPartyApp'
.service 'PlayerData', ['$http', 'Recent'
    class PlayerData
      constructor: ($http, Recent)->
        @http = $http
        @checkRecent = Recent.checkRecent
        @addRecent = Recent.addRecent
        @playerData = {}
        @recentSearches = Recent.getRecent()
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
      searchPlayer: (playerName, error)=>
        # Possibly move functionality of check recent to here.
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