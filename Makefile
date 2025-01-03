# Make settings from:
# https://tech.davis-hansson.com/p/make/
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Variables
DIAGRAM_SOURCES = $(shell find src/_diagrams/*.plantuml | sed 's,src/_diagrams,src/assets/images/diagrams,')
DIAGRAM_FILES= $(DIAGRAM_SOURCES:.plantuml=.png)
DRAFT_FILES = $(shell find src/_drafts/*.md | sed 's,src/_drafts,src/drafts,')
export RCLONE_SFTP_HOST=${RSYNC_NET_HOST}
export RCLONE_SFTP_USER=${RSYNC_NET_USER}

.PHONY: build build_with_drafts deploy_with_drafts diagrams clean logs analyze-logs

Gemfile.lock: Gemfile
	bundle install

build: Gemfile.lock diagrams
	bundle exec jekyll build
	touch .make.build

build_with_drafts: $(DRAFT_FILES) build

test:
	find_broken_links http://127.0.0.1:4000

deploy: build test
	git push origin master
	rsync -av _site/ ylansegal_ylansblog@ssh.nyc1.nearlyfreespeech.net:/home/public
	curl -H 'Cache-Control: no-cache' --head  https://ylan.segal-family.com
	curl -H 'Cache-Control: no-cache' --head  https://ylan.segal-family.com/assets/main.css
	open https://ylan.segal-family.com

deploy_with_drafts: build_with_drafts deploy

diagrams: src/assets/images/diagrams $(DIAGRAM_FILES)

src/assets/images/diagrams:
	mkdir -p src/assets/images/diagrams

src/assets/images/diagrams/%.png: src/_diagrams/%.plantuml
	plantuml $<
	mv $(<:.plantuml=.png) $@

src/drafts/%: src/_drafts/%
	cp $< $@

clean:
	rm $(DIAGRAM_FILES)
	rm $(DRAFT_FILES)

## Log processing
logs:
	mkdir -p logs

logs/access_log: logs
	rsync -av ylansegal_ylansblog@ssh.nyc1.nearlyfreespeech.net:/home/logs/* logs/

logs/report.html: logs/access_log
	goaccess logs/access_log* -o logs/report.html --log-format=COMBINED

.make.backup_logs: logs/report.html
	cat ~/.secure.password | rclone --progress sync logs drive:/blog_logs/
	cat ~/.secure.password | rclone --progress sync logs rsyncnet:blog_logs/
	touch .make.backup_logs

analyze-logs: .make.backup_logs
