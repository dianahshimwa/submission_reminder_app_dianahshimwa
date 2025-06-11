#!/bin/bash

# Ask the user to enter the name

read -p "Please enter your name: " name

# Creating the main directory

maindir="submission_reminder_$name"
mkdir -p "$maindir"
