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

# Sanitazing the variables input

assignment=$(echo "$assignment" | sed "s/$(echo -e '\u00a0')/ /g" | tr -cd '[:alnum:] [:space:]' | xargs)

days=$(echo "$days" | xargs)

echo "DEBUG: [$assignment]"

# Input validation

if [ -z "$assignment" ] || ! [[ "$days" =~ ^[0-9]+$ ]]; then
    echo "The Assignment name cannot be empty🙅."
    echo "and" 
    echo "The Days have to be numbers."
    echo "------------------------------"
    echo "Aborting..."
    exit 1
fi

# Checking if the assignment name are not numerical

if ! echo "$assignment" | grep -qE '^[A-Za-z ]+$'; then
    echo "The Assignment name must contain." 
    echo "only letters and spaces."
    echo "Aborting..."
    exit 1
fi

# Checking if the assignment exists in submissions.txt

matched_assignment=$(grep -i ", *$assignment," "$submissions_file" | awk -F',' '{print $2}' | head -n1 | xargs)

if [ -z "$matched_assignment" ]; then
    echo "Assignment '$assignment' isn't found in submissions.txt"
    echo "Try again."
    echo "Aborting..."
    exit 1
fi

# Update config.env

echo "Updating config.env in $maindir/config/"
echo "ASSIGNMENT=\"$matched_assignment\"" > "$maindir/config/config.env"
echo "DAYS_REMAINING=$days" >> "$maindir/config/config.env"

echo "Configuration updated!"
cat "$maindir/config/config.env"

# Ask if they want to start the app

if [[ "$choice" =~ ^[Yy]$ ]]; then
    echo "...Starting the app..."
    bash "$maindir/startup.sh"
    echo "The app has started and running"
else
    echo "Reminder app not started."
    echo "You can run it later using: bash $maindir/startup.sh"
fi
