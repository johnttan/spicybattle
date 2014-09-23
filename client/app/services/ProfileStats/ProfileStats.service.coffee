'use strict'

angular.module 'spicyPartyApp'
.service 'ProfileStats', [
  class ProfileStats
    constructor: ->
    getStats: (gameLog)=>
      gamesAnalyzed = gameLog.length
      [champStats, packStats] = @calcChampsAndPacks(gameLog)

      return {
        champStats: champStats
        packStats: packStats
        gamesAnalyzed: gamesAnalyzed
      }
    calcChampsAndPacks: (gameLog)->
      champTemp = {
        elo: 0
        wins: 0
        scoreTotal: 0
        losses: 0
        kills: 0
        deaths: 0
        assists: 0
        belts: {}
        jungleMobs: 0
        }    
      packTemp = {
        wins: 0
        losses: 0
      }

      champStats = {}
      packStats = {}
      _.each(gameLog, (el)->
        if el.playerName not of champStats
          champStats[el.playerName] = _.clone(champTemp)
        if el.belt not of packStats
          packStats[el.belt] = _.clone(packTemp)
        _.each(el, (el1, key)->
          if key of champTemp
            champStats[el.playerName][key] += el1
          if key of packTemp
            packStats[el.belt][key] += el1
          return
        )

        if parseInt(el.elo) > 0
          champStats[el.playerName].wins += 1
          packStats[el.belt].wins += 1
        else
          champStats[el.playerName].losses += 1
          packStats[el.belt].losses += 1
        if champStats[el.playerName].belts[el.belt]
          champStats[el.playerName].belts[el.belt] += 1
        else
          champStats[el.playerName].belts[el.belt] = 1
        return
      )
      return [champStats, packStats]


]
