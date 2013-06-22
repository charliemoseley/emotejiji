# https://github.com/intridea/grape/issues/340#issuecomment-13777954

module MyApp
  class ParamsParser < ActionDispatch::ParamsParser
    def initialize(app, opts = {})
      @app = app
      @opts = opts
      super
    end

    def call(env)
      if @opts[:ignore_prefix].nil? or !env['PATH_INFO'].start_with?(@opts[:ignore_prefix])
        super(env)
      else
        @app.call(env)
      end
    end
  end
end