.PHONY: build deploy

Gemfile.lock: Gemfile
	bundle install

build: Gemfile.lock
	bundle exec jekyll build

deploy: build
	rsync -av _site/ ylansegal_ylansblog@ssh.phx.nearlyfreespeech.net:/home/public
