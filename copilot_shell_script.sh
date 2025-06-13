#!/bin/bash

# Ask the user to enter the directory name

read -p "Enter your name (used in the environment folder name): " name
maindir="submission_reminder_$name"

# Checking if the directory exists

if [ ! -d "$maindir" ]; then
    echo "Directory '$maindir' is not found. Please run create_environment.sh first."
    exit 1
fi

# Ask the user to enter the assignment and days remaining

read -p "Enter the assignment name: " assignment
read -p "Enter number of days remaining to submit: " days

# Input validation

if [ -z "$assignment" ] || ! [[ "$days" =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Assignment must not be empty and days must be a number."
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

