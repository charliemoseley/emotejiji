class StaticGeneratorController < ApplicationController
  def generate
    render text: "will generate a static html page"
  end
end
