# Inspired from:
# https://github.com/indabamusic/rack-escaped-fragment/
require "rack"
require "uri"

module Rack
  class EscapedFragment
    def initialize(app)
      @app = app
    end

    def call(env)
      req = ::Rack::Request.new(env)

      if fragment = req.params["_escaped_fragment_"]
        original_fullpath = req.fullpath
        uri = URI.parse(fragment)

        # Set the original url to be accessed later
        env["ESCAPED_FRAGMENT"] = original_fullpath

        # Rewrite the url
        env["PATH_INFO"]    = uri.path
        env["QUERY_STRING"] = uri.query || ""
        env["REQUEST_URI"]  = req.fullpath
      end

      @app.call(env)
    end
  end
end

module Rack
  class Request
    def escaped_fragment
      @env["ESCAPED_FRAGMENT"]
    end

    def escaped_fragment?
      @env["ESCAPED_FRAGMENT"] ? true : false
    end
  end
end