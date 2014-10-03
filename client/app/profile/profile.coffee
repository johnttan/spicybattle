'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.profile',
    url: '^/:player/profile'
    sticky: true
    deepStateRedirect: true
