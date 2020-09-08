# UNIX Socketへのバインド
rails_root = "/var/www/rails"
bind "unix://#{rails_root}/tmp/sockets/puma.sock"

# スレッド数とWorker数の指定
threads 3, 3
workers 2
preload_app!

# デーモン化の設定
daemonize
pidfile "#{tmp_path}/pids/puma.pid"
stdout_redirect "#{tmp_path}/logs/puma.stdout.log", "#{tmp_path}/logs/puma.stderr.log", true

# rails restartコマンドが使えます。
plugin :tmp_restart

# puma_worker_killerの設定
before_fork do
  PumaWorkerKiller.config do |config|
    # 閾値を超えた場合にkillする
    config.ram           = 1024 # mb
    config.frequency     = 5 * 60 # per 5minute
    config.percent_usage = 0.9 # 90%
    # 閾値を超えたかどうかに関わらず定期的にkillする
    config.rolling_restart_frequency = 24 * 3600 # per 1day
    # workerをkillしたことをログに残す
    config.reaper_status_logs = true
  end
  PumaWorkerKiller.start
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
