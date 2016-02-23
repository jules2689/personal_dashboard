class HeadspacePackGroup < ActiveRecord::Base
  belongs_to :headspace_stat

  # HTTP -> HTTPS converter for icons
  %w( icon_url ldpi_icon_url mdpi_icon_url hdpi_icon_url xhdpi_icon_url xxhdpi_icon_url ).each do |url|
    define_method "https_#{url}" do
      u = self.send(url)
      unless u.start_with?("https")
        u.gsub!(/^http:\/\/([\w-]+)\.(?:r\d+|ssl)\.cf(\d)\.rackcdn\.com(.*)/,'https://\1.ssl.cf\2.rackcdn.com/\3')
      end
      u
    end
  end

end
