window.App = angular.module('Emotejiji', ['restangular', 'ui.state'])

App.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl("/api/v1")

# Random tutorial notes

# Angular forEach vs underscoe .each
# http://jsperf.com/angular-foreach-vs-underscore-foreach/2
# Almost exactly the same so I'm going to with the underscore syntax since I find it prettier.