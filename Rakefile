require "sinatra/activerecord/rake"
require 'yaml'

environment = ENV['RACK_ENV'] || 'development'
db = YAML.load_file('config/database.yml')[environment]
ActiveRecord::Base.establish_connection(db)

namespace :assets do
  require 'bundler'
  require 'sprockets'
  require 'dashing'
  require 'uglifier'

  root = File.realdirpath('.')
  sprockets = Sinatra::Application.settings.sprockets
  outpath_prefix = File.join(root, 'public', Sinatra::Application.settings.assets_prefix)

  desc 'Compile assets'
  task precompile: [:clean, :compile_js, :compile_css, :move_fonts] do
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
    Dir[File.join(root, 'assets', 'fonts', '*')].each do |font|
      out_path = Pathname.new(outpath_prefix).join(File.basename(font))
      FileUtils.cp font, out_path
    end
  end
end

namespace :ssl do
  desc "Renew SSL certificates"
  task :renew do
    require 'le_ssl'
    require 'le_ssl/manager'

    email = 'julian@jnadeau.ca'
    domain = 'dashboard.jnadeau.ca'

    base_path = '/etc/letsencrypt/live/dashboard.jnadeau.ca'
    private_key = File.read("/etc/letsencrypt/live/dashboard.jnadeau.ca/privkey.pem")
    manager = LeSSL::Manager.new(
      email: email,
      agree_terms: true,
      private_key: private_key,
      key_paths: {
        priv_key: File.join(base_path, 'privkey.pem'),
        cert: File.join(base_path, 'cert.pem'),
        chain: File.join(base_path, 'chain.pem'),
        full_chain: File.join(base_path, 'fullchain.pem')
      },
      public_path: '/home/deploy/apps/personal_dashboard/current/public'
    )

    puts "Authorizing for domain #{domain}"
    manager.authorize_for_domain(domain)

    puts "Requesting certificate for #{domain}"
    manager.request_certificate(domain)
  end
end
