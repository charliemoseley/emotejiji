class StaticGeneratorController < ApplicationController
  layout 'escaped_fragment'

  def generate
    url = request.fullpath.split('/').reject(&:empty?)
    @meta = OpenStruct.new
    @meta.title = "Emotejiji, the emoticon / text face tagging and search engine."
    @meta.description = "Emotejiji is a tagging and search engine for emoticons/emoji and text faces.  Find, discover, and copy your way to awesome emoticons wherever you need them! :D"
    @meta.url = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"


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
    @meta.title =  @emoticon.text + " :: " + @emoticon.description + " emoticon / text face :: Emotejiji"
    flattened_tags = @emoticon.tags.keys.join(", ")
    @meta.description =  @emoticon.description + " :: emoticon / text face for " + flattened_tags
  end

  def available_tags
    @emoticons = Emote.all
    @tags = []
    @emoticons.each { |e| @tags << e.tags.keys }
    @tags.flatten!.uniq!
  end
end