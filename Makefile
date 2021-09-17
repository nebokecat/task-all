# make rspec
rspec:
	docker-compose run --rm app bundle exec rspec
