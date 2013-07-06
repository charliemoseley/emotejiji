# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.all.each do |u|
  u.delete
end

Emote.all.each do |e|
  e.delete
end

user = User.create(username: "emotejiji_robot", password: "c1j2m3c1j2m3", password_confirmation: "c1j2m3c1j2m3")

emotes = JSON.parse(File.read("db/emotes.json"))
emotes.each do |e|
  emote = Emote.new
  emote.text = e["text"]
  emote.tags = e["tags"]
  emote.description = e["description"]
  begin
    emote.create_with(user)
  rescue
  end
end

Emote.first.favorited_by user
Emote.last.favorited_by user