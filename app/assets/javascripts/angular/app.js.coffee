window.App = angular.module('Emotejiji', ['restangular', 'ui.state'])

App.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl("/api/v1")

App.config ($stateProvider, $routeProvider) ->
  $stateProvider
    .state('index', {
      url: '', # root route
      views: {
        'emoticonList': {
          templateUrl: '/angular/emoticon_list',
          controller: 'EmoticonListCtrl'
        }
      }
    })
    .state 'singleEmoticon', {
        url: '/emoticons/{id}',
        views: {
          'emoticonList': {
            templateUrl: '/angular/emoticon_list',
            controller: 'EmoticonListCtrl'
          },
          'popOver': {
            templateUrl: '/angular/emoticon',
            controller: 'EmoticonCtrl'
          }
        }
      }