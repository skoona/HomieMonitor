#!/usr/bin/env puma

# config/puma.rb

directory '.'
rackup 'config.ru'
environment ENV.fetch('RACK_ENV', 'development')
daemonize false
pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'
threads 0, 8
bind "tcp://0.0.0.0:#{ENV.fetch('RACK_PORT', 8585 ) }"

# Redirect STDOUT and STDERR to files specified. The 3rd parameter
# ("append") specifies whether the output is appended, the default is
# "false".
#
# stdout_redirect '/u/apps/lolcat/log/stdout', '/u/apps/lolcat/log/stderr'
# stdout_redirect '/u/apps/lolcat/log/stdout', '/u/apps/lolcat/log/stderr', true

# Disable request logging.
#
# The default is "false".
#
# quiet


# Bind the server to "url". "tcp://", "unix://" and "ssl://" are the only
# accepted protocols.
#
# The default is "tcp://0.0.0.0:9292".
#
# bind 'tcp://0.0.0.0:9292'
# bind 'unix:///var/run/puma.sock'
# bind 'unix:///var/run/puma.sock?umask=0111'
# bind 'ssl://127.0.0.1:9292?key=path_to_key&cert=path_to_cert'
# bind 'tcp://0.0.0.0:3000'

# Instead of "bind 'ssl://127.0.0.1:9292?key=path_to_key&cert=path_to_cert'" you
# can also use the "ssl_bind" option.
#
# ssl_bind '127.0.0.1', '9292', {
#   key: path_to_key,
#   cert: path_to_cert
# }
# for JRuby additional keys are required:
# keystore: path_to_keystore,
# keystore_pass: password

# Code to run before doing a restart. This code should
# close log files, database connections, etc.
#
# This can be called multiple times to add code each time.
#
# on_restart do
#   puts 'On restart...'
# end

# Command to use to restart puma. This should be just how to
# load puma itself (ie. 'ruby -Ilib bin/puma'), not the arguments
# to puma, as those are the same as the original process.
#
# restart_command '/u/app/lolcat/bin/restart_puma'
