'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.home',
    url: ''
    sticky: true
    deepStateRedirect: true
