App.service "BrowserStateService", ->
  this.client  = 'generic'
  this.os      = 'generic'
  this.browser = 'generic'
  this.flash   = false

  this.isFlashEnabled = ->
    hasFlash = false
    try
      hasFlash = true if new ActiveXObject('ShockwaveFlash.ShockwaveFlash')
    catch e
      hasFlash = true if navigator.mimeTypes["application/x-shockwave-flash"] != undefined
    hasFlash

  this.load = ->
    this.flash = this.isFlashEnabled()
    console.log this.flash

  this