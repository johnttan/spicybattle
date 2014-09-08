'use strict'

angular.module 'spicyPartyApp'
.service 'Recent', ($state, localStorageService)->
	do(rec=@)->
		rec.searches = localStorageService.get('searches')
		if not rec.searches
			rec.searches = {}
		rec.addRecent = (playerName, playerData, leader)->
			display = false
			if not leader
				display = true
			if playerName in Object.keys(rec.searches)
				display = true
			recentData = {time: new Date(), data: playerData, display: display}
			rec.searches[playerName] = recentData
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