web: bundle exec rails server -p $PORT -e $RAILS_ENV
worker: bundle exec sidekiq -c $WORKER_CONCURRENCY -e $RAILS_ENV -q critical  -q default
