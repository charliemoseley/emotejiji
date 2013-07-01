App.directive "zeroClipboard", (ZeroClipboardService) ->
  (scope, element, attrs) ->
    unless angular.isDefined scope.zeroClipboard
      scope.zeroClipboard = new ZeroClipboardService(element, { moviePath: '/ZeroClipboard.swf' })
    clip = scope.zeroClipboard

    clip.htmlBridge.style.position = 'fixed'
    clip.on 'complete', ->
      $('#clipboard-success').show().delay('600').fadeOut()