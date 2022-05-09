web: bundle exec puma -p $PORT -e $RAILS_ENV
worker: bundle exec sidekiq -C config/sidekiq.yml -e $RAILS_ENV