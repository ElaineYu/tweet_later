web: bundle exec rackup config.ru -p $PORT

worker: bundle exec sidekiq -e production -C config/sidekiq.yml
