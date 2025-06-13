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

[ ! -f "$maindir/app/reminder.sh" ] && touch "$maindir/app/reminder.sh"
[ ! -f "$maindir/modules/functions.sh" ] && touch "$maindir/modules/functions.sh"
[ ! -f "$maindir/assets/submissions.txt" ] && touch "$maindir/assets/submissions.txt"
[ ! -f "$maindir/config/config.env" ] && touch "$maindir/config/config.env"
[ ! -f "$maindir/startup.sh" ] && touch "$maindir/startup.sh"

#Adding content in the files and subdirectories

echo '
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
' >> $maindir/app/reminder.sh

echo '
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
' >> $maindir/modules/functions.sh

echo '
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
' >> $maindir/assets/submissions.txt

echo '
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
' >> $maindir/config/config.env

# Adding names and content to startup.sh

cat <<EOL >> "$maindir/assets/submissions.txt"
Dianah, Git, not submitted
Dalynah, Shell Navigation, submitted
Naomi, Git, not submitted
Debra, Shell Basics, not submitted
Gryta, Shell Basics, submitted
EOL

# Create the startup.sh with logic to run the app

cat << 'EOL' > "$maindir/startup.sh"
#!/bin/bash
# Startup script for Submission Reminder App

source ./config/config.env
source ./modules/functions.sh
bash ./app/reminder.sh
EOL

# Make the files executable

chmod +x "$maindir/app/reminder.sh"
chmod +x "$maindir/modules/functions.sh"
chmod +x "$maindir/assets/submissions.txt"
chmod +x "$maindir/config/config.env"
chmod +x "$maindir/startup.sh"

# Tell the user that it is created

echo "Setup complete"
echo "Please check: $maindir"
