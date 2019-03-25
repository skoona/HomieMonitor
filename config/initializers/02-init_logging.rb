# ##
# 02-init_logging
#

begin
  Logging.init(:debug, :info, :perf, :warn, :error, :fatal)
  dpattern = Logging.layouts.pattern({ pattern: '%d %c:%-5l %m\n', date_pattern: '%Y-%m-%d %H:%M:%S.%3N' })
   std_out = Logging.appenders.stdout( $stdout, :layout => dpattern)

  Logging.logger.root.level     = :debug # (SknApp.env.production? ? :info : :debug )
  Logging.logger.root.appenders = std_out
  SknApp.config.logger          = Logging.logger['ESP']
  SknApp.config.debug_logger    = Logging.logger['HMIE']

  SknApp.logger.info "SknApp Logger Setup Complete! loaded: #{SknApp.env}"

rescue StandardError => e
  $stderr.puts e
  $stderr.puts e.message
  $stderr.puts e.backtrace
  exit 1
end
