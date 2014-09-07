'use strict'

angular.module 'spicyPartyApp'
.service 'Recent', ($state, localStorageService)->
	do(rec=@)->
		rec.searches = localStorageService.get('searches')
		if not rec.searches
			rec.searches = {}
		rec.addRecent = (playerName, playerData)->
			rec.searches[playerName] = {time: new Date(), data: playerData}
			localStorageService.set('searches', rec.searches)
			return rec.searches
		rec.checkRecent = (playerName)->
			playerData = rec.searches[playerName]
			if playerData
				return playerData.data
			else
				return false
		rec.getRecent = ->
			return rec.searches
		rec.clearHistory = ->
			delete rec.searches
			localStorageService.set('searches', {})
			rec.searches = {}
			return rec.searches
	return @