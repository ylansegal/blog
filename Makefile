# Make settings from:
# https://tech.davis-hansson.com/p/make/
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


DIAGRAM_SOURCES = $(find src/_diagrams)
# OBJECTS = $(SOURCES:.c=.o)
# EXECUTABLE = $(OBJECTS:.o=)

.PHONY: build deploy diagrams

Gemfile.lock: Gemfile
	bundle install

build: Gemfile.lock
	bundle exec jekyll build

deploy: build
	git push origin master
	rsync -av _site/ ylansegal_ylansblog@ssh.phx.nearlyfreespeech.net:/home/public

.diagrams.sentinel: $(find src/_diagrams/*.plantuml)
	plantuml src/_diagrams/*.plantuml
	mv src/_diagrams/*.png _site/assets/images/
	touch .diagrams.sentinel

diagrams: .diagrams.sentinel
