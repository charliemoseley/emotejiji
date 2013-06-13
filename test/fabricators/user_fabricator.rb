Fabricator(:user) do
  email                 { mock_email }
  username              { Faker::Lorem.characters(8) }
  password              { Faker::Lorem.characters(12) }
  password_confirmation { |attrs| attrs[:password] }
end

# May sometimes result in an empty {}, which is good, as sometimes something
# wont be tagged.
def mock_email
  Faker::Internet.email if [true, false].sample
end