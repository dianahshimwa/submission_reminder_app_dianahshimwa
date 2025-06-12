#!/bin/bash
# Startup script for Submission Reminder App

source ./config/config.env
source ./modules/functions.sh
bash ./app/reminder.sh
