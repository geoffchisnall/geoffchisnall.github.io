#!/usr/bin/bash

echo 'creating TAGs and Categories'
cd geoffchisnall.github.io
_scripts/sh/create_pages.sh
_scripts/sh/dump_lastmod.sh

echo 'pushing to github'
git add --all
git commit -m "pushing to repo"
git push
