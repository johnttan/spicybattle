'use strict'

angular.module 'spicyPartyApp'
.config ($stateProvider) ->
  $stateProvider.state 'main.profile',
    url: '^/:player/profile'
    views: {
      'profile@main':{
        templateUrl: 'app/profile/profile.html'
        controller: 'ProfileCtrl'
      }
    }
    sticky: true
    deepStateRedirect: true
