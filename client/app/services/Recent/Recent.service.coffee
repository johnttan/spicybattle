'use strict'

angular.module 'spicyPartyApp'
.service 'Recent', ($state)->
	do(rec=@)->
		rec.searches = {}
		rec.addRecent = (playerName)->
					rec.searches[playerName] = {time: new Date()}
					return rec.searches
		rec.getRecent = ->
			return rec.searches
		rec.clearHistory = ->
			delete rec.searches
			rec.searches = {}
			return rec.searches
	return @