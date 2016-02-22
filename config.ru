require 'dotenv'
Dotenv.load

require "sinatra/activerecord"
Dir["#{File.dirname(__FILE__)}/models/*.rb"].each { |f| require(f) }
require 'dashing'

configure do
  set :auth_token, ENV["AUTH_TOKEN"]
  set :default_dashboard, 'overview'

  helpers do
    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      credentials = [ENV["HTTP_USER"], ENV["HTTP_PASSWORD"]]
      @auth.provided? && @auth.basic? &&
        @auth.credentials && @auth.credentials == credentials
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
