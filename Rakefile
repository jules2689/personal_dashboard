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
  task :precompile => [:clean, :compile_js, :compile_css, :move_fonts] do
    puts '*** Sucessfuly Precompiled'
  end

  desc 'Clean assets folder'
  task :clean do
    puts '*** Cleaning compiled assets'
    FileUtils.rm_rf File.join(outpath_prefix)
    FileUtils.mkdir File.join(outpath_prefix)
    puts '*** Successfully cleaned assets'
  end

  desc 'Precompile JS assets for production'
  task :compile_js do
    puts '*** Compiling js assets'
    sprockets = Sinatra::Application.settings.sprockets
    sprockets.js_compressor = Uglifier.new(mangle: false)
    asset = sprockets['application.js']
    outfile = Pathname.new(outpath_prefix).join('application.js')
    asset.write_to(outfile)
    puts "*** Successfully compiled js assets"
  end

  desc 'Precompile CSS assets for production'
  task :compile_css do
    puts '*** Compiling css assets'
    sprockets.css_compressor = :scss
    asset = sprockets['application.css']
    outfile = Pathname.new(outpath_prefix).join('application.css')
    asset.write_to(outfile)
    puts "*** Successfully compiled css assets"
  end

  desc 'Copy Font assets for production'
  task :move_fonts do
    puts '*** Moving Fonts'
    Dir[File.join(root, 'assets', 'fonts','*')].each do |font|
      out_path = Pathname.new(outpath_prefix).join(File.basename(font))
      FileUtils.cp font, out_path
    end
  end
end