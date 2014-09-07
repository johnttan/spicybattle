'use strict'

angular.module 'spicyPartyApp'
.service 'Recent', ($state, localStorageService)->
	do(rec=@)->
		rec.searches = {}
		rec.addRecent = (playerName, playerData)->
			rec.searches[playerName] = {time: new Date()}
			localStorageService.set(playerName, playerData)
			return rec.searches
		rec.checkRecent = (playerName)->
			playerData = localStorageService.get(playerName)
			return playerData
		rec.getRecent = ->
			return rec.searches
		rec.clearHistory = ->
			delete rec.searches
			localStorageService.clearAll()
			rec.searches = {}
			return rec.searches
	return @