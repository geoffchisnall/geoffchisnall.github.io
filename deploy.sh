#!/usr/bin/bash

echo 'creating TAGs and Categories'
_scripts/sh/create_pages.sh
_scripts/sh/dump_lastmod.sh

echo 'pushing to github'
git add --all
git commit -m "Grammar errors, thanks parity0x1 ;)"
git push
