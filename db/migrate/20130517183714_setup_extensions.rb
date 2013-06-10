class SetupExtensions < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'
    enable_extension 'hstore'
  end
end
