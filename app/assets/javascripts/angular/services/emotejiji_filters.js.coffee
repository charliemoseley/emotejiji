angular.module('emotejijiFilters', [])
  .filter('emoticonLinkFilter', ->
    (input) ->
      if input == 'all' then 'emoticons' else input
  )