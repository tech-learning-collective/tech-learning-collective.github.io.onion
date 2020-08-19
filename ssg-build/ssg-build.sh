#!/bin/bash
#
# PHASE 1:
# Script to run prepare the static site generator (SSG) build.

# Install the correct Bundler version, whatever it is.
gem install bundler:"$(grep -A 1 "BUNDLED WITH" /srv/jekyll/Gemfile.lock | tail -n 1 | tr -d ' ')"

# Call out to the parent container's own entrypoint.
/usr/jekyll/bin/entrypoint "$@"
