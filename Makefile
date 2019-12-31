.PHONY: build deploy

Gemfile.lock: Gemfile
	bundle install

build: Gemfile.lock
	bundle exec jekyll build

deploy: Gemfile.lock
	echo "This is where I deploy"
