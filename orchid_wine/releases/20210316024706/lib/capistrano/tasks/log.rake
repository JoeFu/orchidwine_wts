namespace :log do
  desc "tailf production log. file in lib/capistrano/tasks/log.rake"
  task :tf do
    on roles(:app) do
      execute "tail -f #{current_path}/log/production.log"
    end
  end
end