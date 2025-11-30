#!/usr/bin/env bash

# macOS Setup Script
# Source: https://mths.be/macos

# --- PREAMBLE ---

# Close any open System Preferences panes to prevent them from overriding settings
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- SYSTEM ---

# Set computer name (as done via System Preferences -> Sharing)
sudo scutil --set ComputerName "maac"
sudo scutil --set HostName "maac"
sudo scutil --set LocalHostName "maac"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "maac"

# Disable reopening apps on reboot
# https://www.tonymacx86.com/threads/guide-permanently-disable-macos-from-re-opening-apps-on-restart-boot.296200/
sudo chown root ~/Library/Preferences/ByHost/com.apple.loginwindow.*
sudo chmod 000 ~/Library/Preferences/ByHost/com.apple.loginwindow.*

# --- GENERAL UI/UX ---

# Move a window by clicking on any part of it while holding cmd+ctrl
defaults write -g NSWindowShouldDragOnGesture -bool true

# Set 'Prefer tabs when opening documents' to 'Always'
defaults write -g AppleWindowTabbingMode -string "always"

# Set a faster keyboard repeat rate
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 25 # Default is 15 (225ms)

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"

# Disable automatic spelling correction
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Save new documents to disk (not to iCloud) by default
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Show all filename extensions
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"

# --- KEYBOARD ---

# Use F-keys as standard function keys
defaults write com.apple.HIToolbox AppleFnUsageType -int "0"

# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"

# --- TRACKPAD & MOUSE ---

# Enable tap to click for this user and for the login screen
# NOTE: You have this setting twice. The `-currentHost` is more specific.
# You can likely remove the second one.
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# --- DOCK, MISSION CONTROL & HOT CORNERS ---

# Don't show recent applications in Dock
defaults write com.apple.dock "show-recents" -bool "false"

# Automatically hide and show the Dock
defaults write com.apple.dock "autohide" -bool "true"

# Set the icon size of Dock items in pixels
defaults write com.apple.dock "tilesize" -int "36"

# Set Dock orientation to the left
defaults write com.apple.dock "orientation" -string "left"

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Displays have separate Spaces
defaults write com.apple.spaces "spans-displays" -bool "true" && killall SystemUIServer

# Group windows by application in Mission Control
defaults write com.apple.dock "expose-group-apps" -bool "true" && killall Dock

# Disable 'Standard Click to Show Desktop'
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# --- FINDER ---

# Keep folders on top when sorting by name
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

# When performing a search, search the current folder by default
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCev"

# Set list view as the default view style
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"

# Show the path bar
defaults write com.apple.finder "ShowPathbar" -bool "true"

# Show hidden files
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"

# Remove items from the Trash after 30 days
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"

# --- SECURITY ---

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices "LSQuarantine" -bool "false"

# --- SOUND & AUDIO ---

# Disable UI sound effects
defaults write -g com.apple.sound.uiaudio.enabled -int 0

# Disable the startup chime
sudo nvram StartupMute=%01

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# --- DISPLAY ---

# Enable subpixel font rendering on non-Apple LCDs
#Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# --- SOFTWARE UPDATES ---

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# --- DEFAULT APPLICATIONS ---

# Set ForkLift as the default file viewer
defaults write -g NSFileViewer -string com.binarynights.ForkLift;
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType="public.folder";LSHandlerRoleAll="com.binarynights.ForkLift";}'

# --- APPLY CHANGES ---

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Google Chrome Canary" \
	"Google Chrome" \
	"Mail" \
	"Messages" \
	"Opera" \
	"Photos" \
	"Safari" \
	"SizeUp" \
	"Spectacle" \
	"SystemUIServer" \
	"Terminal" \
	"Transmission" \
	"Tweetbot" \
	"Twitter" \
	"iCal"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
