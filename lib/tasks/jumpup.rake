INTEGRATION_TASKS = %w(
  jumpup:heroku:start
  jumpup:start
  jumpup:bundle_install
  db:migrate
  spec
  jumpup:git:check_last_commit_change
  jumpup:heroku:finish
  jumpup:finish
)
