namespace :db do

  desc "Seed the database. file in lib/capistrano/tasks/db.rake"
  task :migrate do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "db:migrate"
          execute :rake, "db:seed"
        end
      end
    end
  end
end