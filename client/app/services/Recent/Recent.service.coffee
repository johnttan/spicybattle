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

		rec.checkRecent = (playerName, searchPlayer)->
			clearTimeout(rec.poll)
			playerData = rec.searches[playerName]
			outdated = true
			if playerData
				now = new Date().getTime()
				difference = now - playerData.data.modifiedDate
				outdated = difference > 850000
			if not outdated
				future = (850000+playerData.data.modifiedDate-now)
				rec.poll = setTimeout(searchPlayer.bind(undefined, playerName), future)
				console.log 'set poll for', playerName, future + ' ms in the future'
				return playerData.data
			else
				rec.poll = setTimeout(searchPlayer.bind(undefined, playerName), 300000)
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