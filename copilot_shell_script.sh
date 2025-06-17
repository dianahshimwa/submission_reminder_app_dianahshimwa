#!/bin/bash

# Ask the user to enter the directory name

read -p "Enter your name (used in the environment folder name): " name

if [ -z "$name" ]; then
	echo "Please enter your name."
	echo "-------------------------"
	echo "Aborting..."
	exit 1
fi
if ! [[ "$name" =~ ^[a-zA-Z\s]+$ ]]; then
    echo "The Assignment name must contain."
    echo "only letters and spaces."
    echo "Aborting..."
    exit 1
fi

# Adding variables to the directory

maindir="submission_reminder_$name"
submissions_file="$maindir/assets/submissions.txt"

# Checking if the directory exists

if [ ! -d "$maindir" ]; then
	echo "Directory '$maindir' not found"
	echo "Please run create_environment.sh."
	echo "Aborting..."
	exit 1
fi

# Ask the user to enter the assignment and days remaining

read -p "Enter the assignment name: " assignment
read -p "Enter number of days remaining to submit: " days

# Input validation

if [ -z "$assignment" ] || ! [[ "$days" =~ ^[0-9]+$ ]]; then
    echo "Assignment name cannot be empty and the days must be numbers."
    exit 1
fi

if ! [[ "$assignment" =~ ^[a-zA-Z\s]+$ ]]; then
    echo "Assignment name must contain only letters and spaces."
    exit 1
fi

if ! grep -iq ", *$assignment," "$SUBMISSIONS_FILE"; then
    echo " Assignment '$assignment' not found in submissions.txt"
    exit 1
fi

# Update config.env

echo "Updating config.env in $maindir/config/"
echo "ASSIGNMENT=\"$assignment\"" > "$maindir/config/config.env"
echo "DAYS_REMAINING=$days" >> "$maindir/config/config.env"

echo "Configuration has been updated:"
cat "$maindir/config/config.env"

# Ask if they want to start the app

read -p "Would you like to run the reminder app now? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
    echo "Starting the app..."
    bash "$maindir/startup.sh"
else
    echo "Reminder app not started. You can run it later using: bash $maindir/startup.sh"
fi

