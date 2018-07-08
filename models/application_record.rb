require "yaml"
require "sqlite3"
require "active_record"

class ApplicationRecord < ActiveRecord::Base
  APP_ENV = ENV['APP_ENV'] || 'development'
  DB_CONFIG_PATH = "./config/database.yml"
  DB_CONFIG = YAML::load(File.open(DB_CONFIG_PATH))[APP_ENV]
  ActiveRecord::Base.establish_connection(DB_CONFIG)

  self.abstract_class = true
end
