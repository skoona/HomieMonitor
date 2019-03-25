# Disable Rake-environment-task framework detection by uncommenting/setting to false
# Warbler.framework_detection = false

# Warbler web application assembly configuration file
Warbler::Config.new do |config|
  config.init_contents << StringIO.new("\nGem.clear_paths\nGem.path\n\n")
  config.features = %w(executable)
  config.dirs = %w(assets bin config content db i18n mains vendor tmp web log spec)
  config.includes = FileList["config.ru", "Gemfile", "Gemfile.lock", "LICENSE", "README.md"]
  config.excludes = FileList["config/**/*.local.yml"]
  config.pathmaps.java_classes << "%{target/classes/,}p"
  config.gem_excludes = [/^(test|spec)\//]
  config.pathmaps.application = ["WEB-INF/%p"]
  config.jar_name = "homie_monitor_esp-#{Skn::VERSION}"
  config.autodeploy_dir = "target/"
  config.gem_path = "WEB-INF/vendor/bundle"
  config.public_html  += FileList["META-INF/context.xml","public/**/*"]
  config.webxml.rack.env = ENV['RACK_ENV'] || 'production'
  config.webxml.rails.env = ENV['RAILS_ENV'] || 'production'
  config.webxml.booter = :rack
  config.webxml.rackup.path = 'WEB-INF/config.ru'
  config.webxml.jruby.min.runtimes = 1
  config.webxml.jruby.max.runtimes = 1
end
