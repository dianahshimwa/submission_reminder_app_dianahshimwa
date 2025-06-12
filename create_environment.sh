#!/bin/bash

# Ask the user to enter the name

read -p "Please enter your name: " name

if [ -z "$name" ]; then
	echo "You must enter a name"
	continue
fi

# Creating the main directory

maindir="submission_reminder_$name"

if [ -d "$maindir" ]; then
	echo "Directory already exists"
	exit 1
else	
        mkdir -p "$maindir"
        echo "Directory was created"  	

fi

# Creating subdirectories and files

mkdir -p "$maindir/app"
mkdir -p "$maindir/modules"
mkdir -p "$maindir/assets"
mkdir -p "$maindir/config"

[ ! -f "$maindir/app/reminder.sh" ] && cp reminder.sh "$maindir/app"
[ ! -f "$maindir/modules/functions.sh" ] && cp functions.sh "$maindir/modules"
[ ! -f "$maindir/assets/submissions.txt" ] && cp submissions.txt "$maindir/assets"
[ ! -f "$maindir/config/config.env" ] && cp config.env "$maindir/config"
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
