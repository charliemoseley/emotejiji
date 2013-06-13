Fabricator(:emote) do
  text        { sequence{ |i| "emote #{i}" } }
  description { Faker::Lorem.sentence }
  tags        { tag_mocker }
end

# May sometimes result in an empty {}, which is good, as sometimes something
# wont be tagged.
def tag_mocker
  mock = {}
  (0...rand(5)).each do
    mock[Faker::Lorem.word.to_sym] = 1 + rand(10)
  end
  mock
end