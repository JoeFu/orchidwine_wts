echo 'orchid_wine start ...'
redis-server /home/orchid/orchid_wine/shared/config/redis_pro.conf
cd /home/orchid/orchid_wine/current && ~/.rvm/bin/rvm ruby-2.5.0@orchid_wine do bundle exec pumactl -S /home/orchid/orchid_wine/shared/tmp/pids/puma.state -F /home/orchid/orchid_wine/current/config/puma/puma.rb start
