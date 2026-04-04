TERMINAL_PLIST=~/Library/Preferences/com.apple.Terminal.plist

cd ${0:a:h}
/usr/libexec/PlistBuddy \
    -c "Add ':Window Settings:Base24 Twilight' dict" \
    -c "Merge 'Base24 Twilight.terminal' ':Window Settings:Base24 Twilight'" \
    -c "Set ':Default Window Settings' 'Base24 Twilight'" \
    -c "Set ':Startup Window Settings' 'Base24 Twilight'" \
    $TERMINAL_PLIST &> /dev/null || true
plutil -convert binary1 $TERMINAL_PLIST

