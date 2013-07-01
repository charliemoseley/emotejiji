window.App = angular.module('Emotejiji', ['restangular', 'ui.state', 'emotejijiFilters'])

App.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl("/api/v1")

App.config ($locationProvider) ->
  $locationProvider.html5Mode true

# Prevent angular from scrolling when ui-view/ng-view is updated by clicking a link
# http://stackoverflow.com/questions/16821798/angular-disable-scroll-to-top-when-changing-view
App.value '$anchorScroll', angular.noop

# Random tutorial notes

# Angular forEach vs underscoe .each
# http://jsperf.com/angular-foreach-vs-underscore-foreach/2
# Almost exactly the same so I'm going to with the underscore syntax since I find it prettier.