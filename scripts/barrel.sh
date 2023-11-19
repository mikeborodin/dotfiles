#!/bin/bash

# Check for the directory argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

# Directory where the barrel file will be created
directory="$1"

# Check if the directory exists
if [ ! -d "$directory" ]; then
  echo "Error: Directory '$directory' not found."
  exit 1
fi

# Create a Dart barrel file in the directory
barrel_file="$directory/$(basename $directory).dart"
echo "Creating Dart barrel file: $barrel_file"

# List Dart files in the directory (excluding the barrel file itself)
# and write export statements to the barrel file
# You may need to modify this depending on your naming conventions
find "$directory" -type f -name '*.dart' ! -name "$(basename "$directory").dart" | sed "s|$directory/|export '|;s|.dart|.dart';|" > "$barrel_file"

echo "Dart barrel file created successfully!"
