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

.PHONY: build deploy diagrams

Gemfile.lock: Gemfile
	bundle install

build: Gemfile.lock diagrams
	bundle exec jekyll build

deploy: build
	git push origin master
	rsync -av _site/ ylansegal_ylansblog@ssh.phx.nearlyfreespeech.net:/home/public

diagrams: $(DIAGRAM_FILES)

src/assets/images/diagrams/%.png: src/_diagrams/%.plantuml
	plantuml $<
	mv $(<:.plantuml=.png) $@
