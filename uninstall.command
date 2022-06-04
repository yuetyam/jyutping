#!/bin/bash

osascript -e 'tell application id "org.jyutping.inputmethod.Jyutping" to if it is running then quit'

rm -r /Users/$USER/Library/Application\ Scripts/org.jyutping.inputmethod.Jyutping
rm -r /Users/$USER/Library/Containers/org.jyutping.inputmethod.Jyutping
rm -r /Users/$USER/Library/Preferences/org.jyutping.inputmethod.Jyutping.plist

rm -r /Users/$USER/Library/Input\ Methods/Jyutping.app
