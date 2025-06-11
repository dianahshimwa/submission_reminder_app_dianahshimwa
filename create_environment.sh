#!/bin/bash

# Ask the user to enter the name

read -p "Please enter your name: " name

# Creating the main directory

maindir="submission_reminder_$name"
mkdir -p "$maindir"

# Creating subdirectories and files

mkdir -p "$maindir/app"
mkdir -p "$maindir/modules"
mkdir -p "$maindir/assets"
mkdir -p "$maindir/config"

mv reminder.sh "$maindir/app"
mv functions.sh "$maindir/modules"
mv submissions.txt "$maindir/assets"
mv config.env "$maindir/config"
touch $maindir/startup.sh

# Make the files executable

chmod +x "$maindir/app/reminder.sh"
chmod +x "$maindir/modules/functions.sh"
chmod +x "$maindir/assets/submissions.txt"
chmod +x "$maindir/config/config.env"
chmod +x "$maindir/startup.sh"

# Tell the user that it is created

echo "Setup complete"
echo "Please check: $maindir"
