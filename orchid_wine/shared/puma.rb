#!/usr/bin/env puma

directory '/home/orchid/orchid_wine/current'
rackup "/home/orchid/orchid_wine/current/config.ru"
environment 'production'

tag ''

pidfile "/home/orchid/orchid_wine/shared/tmp/pids/puma.pid"
state_path "/home/orchid/orchid_wine/shared/tmp/pids/puma.state"
stdout_redirect '/home/orchid/orchid_wine/shared/log/puma_access.log', '/home/orchid/orchid_wine/shared/log/puma_error.log', true


threads 0,16



bind 'unix:///home/orchid/orchid_wine/shared/tmp/sockets/puma.sock'

workers 0





prune_bundler


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end


