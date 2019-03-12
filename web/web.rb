# File: ./web/web.rb

# ##
# Each Directory has a same named file that handles it's includes
# - or we do it all from the first entry
# ##

# Web Interface

require_relative 'skn_web'

# Named Routes and view helpers
['routes', 'helpers'].each do |web_mod|
  Dir["./web/#{web_mod}/**/*.rb"].each do |pgm_resource|
    begin
      require pgm_resource
    rescue LoadError => e
      $stderr.puts "[Boot Web] Ignoring Exception for: #{e.class} #{e.message}"
    end
  end
end
