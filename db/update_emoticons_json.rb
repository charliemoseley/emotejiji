File.open("emoticons.json","w") do |f|
  f.write(Emote.all.to_json)
end