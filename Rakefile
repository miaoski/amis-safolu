# This file based on:
# https://github.com/andhapp/activerecord_sans_rails
# https://gist.github.com/schickling/6762581

require "yaml"
require "sqlite3"
require "active_record"
require "./models/application_record.rb"

namespace :db do
  task :environment do
    APP_ENV = ENV['APP_ENV'] || 'development'
    DB_DIR = "#{Rake.application.original_dir}/db"
    DB_CONFIG_PATH = "#{Rake.application.original_dir}/config/database.yml"
    DB_CONFIG = YAML::load(File.open(DB_CONFIG_PATH))[APP_ENV]
  end

  desc "Migrate the database"
  task migrate: :environment do
    ActiveRecord::Base.establish_connection(DB_CONFIG)
    ActiveRecord::MigrationContext.new("#{DB_DIR}/migrate/").migrate
    Rake::Task["db:schema"].invoke
    puts "Database migrated."
  end

  desc "Rollback the database"
  task rollback: :environment do
    ActiveRecord::Base.establish_connection(DB_CONFIG)
    ActiveRecord::MigrationContext.new("#{DB_DIR}/migrate/").rollback
    Rake::Task["db:schema"].invoke
    puts "Last migration has been reverted."
  end

  desc "Reset the database"
  task reset: [:migrate]

  desc 'Create a db/schema.rb file that is portable against any DB supported by AR'
  task schema: :environment do
    ActiveRecord::Base.establish_connection(DB_CONFIG)
    require 'active_record/schema_dumper'
    filename = "#{DB_DIR}/schema.rb"
    File.open(filename, "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end
end

namespace :g do
  desc "Generate migration"
  task migration: :"db:environment" do
    name = ARGV[1] || raise("Specify name: rake g:migration your_migration")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    path = File.expand_path("#{DB_DIR}/migrate/#{timestamp}_#{name}.rb", __FILE__)

    migration_class = name.split("_").map(&:camelize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration[5.0]
  def up
  end

  def down
  end
end
EOF
    end

    puts "Migration #{path} created"
    abort # needed stop other tasks
  end
end
