#!/bin/bash

# Prompt user for week number
read -p "Enter the week number: " WEEK_NUMBER

# Check if week number is provided
if [ -z "$WEEK_NUMBER" ]; then
  echo "Week number cannot be empty."
  exit 1
fi

WEEK_FOLDER="Weekly Report/Week $WEEK_NUMBER"

# Check if the week folder already exists
if [ -d "$WEEK_FOLDER" ]; then
  echo "The folder for Week $WEEK_NUMBER already exists."
  exit 1
fi

# Create the week folder
mkdir -p "$WEEK_FOLDER"

# Create the markdown files
touch "$WEEK_FOLDER/Week $WEEK_NUMBER-Report-Linkedin.md" # Week1-Report-Linkedin
touch "$WEEK_FOLDER/Week $WEEK_NUMBER-Report-Kitsilano.md"

echo "Created folder and files for Week $WEEK_NUMBER"
