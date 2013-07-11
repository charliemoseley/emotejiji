App.directive "tooltip", ->
  link: (scope, element, attrs) ->
    isEnabled = true
    enabledCheckType = true

    $(element).tooltip { title: attrs.tooltip }

    # We dont need to worry about when something invalid (like undefined) is being watched as watch will always fire once
    # on the first digest
    scope.$watch(
      ->
        scope.$eval(attrs.tooltipEnabled)
      ->
        isEnabled = scope.$eval(attrs.tooltipEnabled)
        enabledCheckType = scope.$eval(attrs.tooltipCheckType)
        unless isEnabled == enabledCheckType
          $(element).tooltip('destroy')
    )
  # TODO: I'm concerned about the performance aspects of continously binding a tooltip over and over again on a digest
    # cycle.  I'm not sure if it's being smart or dumb about it.  Investiage.
