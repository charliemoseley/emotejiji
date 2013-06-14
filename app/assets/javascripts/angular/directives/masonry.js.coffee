App.directive "masonry", ($timeout) ->
  link: (scope, element, attrs) ->
#    scope.$watch 'fEmoticons.length', ->
#      # I don't like how im waiting for a timeout to execute before i run masonry to make sure everying is on the screen.
#      # Stackoverflow a better answer later.
#      $timeout \
#      ->
#        element.masonry {
#          itemSelector: 'li',
#          columnWidth: 110
#        }
#      ,
#      600