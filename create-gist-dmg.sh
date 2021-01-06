#!/bin/sh
test -f gist.dmg && rm gist.dmg
create-dmg \
  --volname "gist.app" \
  --window-pos 450 300 \
  --window-size 450 300 \
  --icon-size 150 \
  --icon "gist.app" 90 70 \
  --hide-extension "gist.app" \
  --hide-extension ".fseventsd" \
  --app-drop-link 300 70 \
  "gist.dmg" \
  "gist/"

#  --volicon "gistcafe.icns" \

