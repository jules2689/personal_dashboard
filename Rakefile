require "sinatra/activerecord/rake"
require 'yaml'

db = YAML.load_file('config/database.yml')["development"]
ActiveRecord::Base.establish_connection(db)

require 'bundler'
Bundler.require

namespace :assets do
  root = File.realdirpath('.')
  sprockets = Sinatra::Application.settings.sprockets
  outpath_prefix = File.join(root, 'public', Sinatra::Application.settings.assets_prefix)

  desc 'Compile assets'
  task :precompile => [:clean, :compile_js, :compile_css] do
    puts '*** Sucessfuly Precompiled'
  end

  desc 'Clean assets folder'
  task :clean do
    puts '*** Cleaning compiled assets'
    if File.exist?(File.join(outpath_prefix, 'application.min.js'))
      FileUtils.rm File.join(outpath_prefix, 'application.min.js')
      puts '**** JS Removed'
    end
    if File.exist?(File.join(outpath_prefix, 'application.min.css'))
      FileUtils.rm File.join(outpath_prefix, 'application.min.css')
      puts '**** CSS Removed'
    end
    puts '*** Successfully cleaned assets'
  end

  desc 'Precompile JS assets for production'
  task :compile_js do
    puts '*** Compiling js assets'
    sprockets = Sinatra::Application.settings.sprockets
    sprockets.js_compressor = Uglifier.new(:mangle => false)
    asset = sprockets['application.js']
    outfile = Pathname.new(outpath_prefix).join('application.min.js')
    asset.write_to(outfile)
    puts "*** Successfully compiled js assets"
  end

  desc 'Precompile CSS assets for production'
  task :compile_css do
    puts '*** Compiling css assets'
    sprockets.css_compressor = :scss
    asset = sprockets['application.css']
    outfile = Pathname.new(outpath_prefix).join('application.min.css')
    asset.write_to(outfile)
    puts "*** Successfully compiled css assets"
  end
end