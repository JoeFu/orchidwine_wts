namespace :whenever do
  desc "force_clear clear crontab and update crontab"

  task :update do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :bundle, :exec, "whenever -f #{shared_path}/config/schedule.rb --clear-crontab"
          execute :cp, "#{current_path}/config/schedule.rb #{shared_path}/config/"
          execute :bundle, :exec, "whenever -f #{shared_path}/config/schedule.rb --update-crontab"
        end
      end
    end
  end
end
