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
		emitSearch = (name)->

		rec.checkRecent = (playerName, boundFunc)->
			clearTimeout(rec.poll)
			playerStats = rec.searches[playerName]
			outdated = true
			if playerStats
				now = new Date().getTime()
				difference = now - playerStats.data.modifiedDate
				outdated = difference > 850000
			if not outdated
				future = (850000+playerStats.data.modifiedDate-now)
				rec.poll = setTimeout(boundFunc, future)
				console.log 'set poll for', playerName, future + ' ms in the future'
				return playerStats.data
			else
				rec.poll = setTimeout(boundFunc, 300000)
				console.log 'set poll for', playerName, '5 minutes in the future'
				return false
		rec.getRecent = ->
			return rec.searches
		rec.clearHistory = ->
			delete rec.searches
			localStorageService.set('searches', {})
			rec.searches = {}
			return rec.searches
	return @