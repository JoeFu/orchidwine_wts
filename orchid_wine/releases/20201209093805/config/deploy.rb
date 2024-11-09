# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

@current_app = "orchid_wine"

set :application, @current_app
set :repo_url, "git@github.com:Wuyue/#{@current_app}.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, "v3.1_release"

# Default deploy_to directory is /var/www/xxx
set :deploy_to, "/home/orchid/#{@current_app}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml", "config/redis.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/upload", "public/img"

# Default value for default_env is {}
set :default_env, { rvm_bin_path: "~/.rvm/bin" }
set :rvm_ruby_version, "ruby-2.5.0@#{@current_app}"

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 3

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :stage, :production
set :default_stage, :production

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_command, "bundle exec whenever"
