class StaticGeneratorController < ApplicationController
  layout 'escaped_fragment'

  def generate
    url = request.fullpath.split('/').reject(&:empty?)
    case url[0]
      when nil
        emoticons_list
        return
      when 'emoticons'
        emoticon(url[1])
        return
      when 'available-tags'
        available_tags
        return
    end
  end

  def emoticons_list
    @emoticons = Emote.all
  end

  def emoticon(id)
    @emoticons = Emote.all
    @emoticon = Emote.find id
  end

  def available_tags
    @emoticons = Emote.all
    @tags = []
    @emoticons.each { |e| @tags << e.tags.keys }
    @tags.flatten!.uniq!
  end
end
