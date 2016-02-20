require "sinatra/activerecord/rake"
require 'yaml'

db = YAML.load_file('config/database.yml')["development"]
ActiveRecord::Base.establish_connection(db)
