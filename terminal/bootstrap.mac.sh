TERMINAL_PLIST=~/Library/Preferences/com.apple.Terminal.plist

cd ${0:a:h}
/usr/libexec/PlistBuddy \
    -c "Add ':Window Settings:Base16 Twilight' dict" \
    -c "Merge 'Base16 Twilight.terminal' ':Window Settings:Base16 Twilight'" \
    -c "Set ':Default Window Settings' 'Base16 Twilight'" \
    -c "Set ':Startup Window Settings' 'Base16 Twilight'" \
    $TERMINAL_PLIST &> /dev/null || true
plutil -convert binary1 $TERMINAL_PLIST

