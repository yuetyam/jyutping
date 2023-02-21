#!/usr/bin/env bash

osascript -e 'tell application id "org.jyutping.inputmethod.Jyutping" to if it is running then quit'

rm -rf ~/Library/Input\ Methods/Jyutping.app
rm -rf ~/Library/Application\ Scripts/org.jyutping.inputmethod.Jyutping
rm -rf ~/Library/Containers/org.jyutping.inputmethod.Jyutping
rm -rf ~/Library/Preferences/org.jyutping.inputmethod.Jyutping.plist
