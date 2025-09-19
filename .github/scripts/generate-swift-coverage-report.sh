#!/bin/bash

# Get project name from current directory or use environment variable
PROJECT_NAME=${PROJECT_NAME:-$(basename "$(pwd)")}
SOURCE_PATH=${SOURCE_PATH:-"${PROJECT_NAME}/Sources"}

CODECOV_PATH=$(swift test --enable-code-coverage --show-codecov-path)

FILES_LINE_COUNTS=$(jq -r --arg source_path "$SOURCE_PATH" '.data[0].files[] | select(.filename | contains($source_path)) | .summary.lines' "$CODECOV_PATH")

total_lines=0
covered_lines=0

# Loop through each file's line count data (FILES_LINE_COUNTS)
for lines_data in $(echo "$FILES_LINE_COUNTS" | jq -c '.'); do
  # Extract total and covered lines for each file
  total=$(echo "$lines_data" | jq '.count')
  covered=$(echo "$lines_data" | jq '.covered')

  # Add to the total lines and covered lines
  total_lines=$((total_lines + total))
  covered_lines=$((covered_lines + covered))
done

# Calculate the average line coverage percentage
if [ $total_lines -gt 0 ]; then
  average_coverage=$(echo "scale=6; $covered_lines * 100 / $total_lines" | bc)  # Keep 6 decimal places
else
  average_coverage=0
fi

average_coverage_rounded=$(echo "$average_coverage" | awk '{print int($1 * 100 + 0.5) / 100}')
average_coverage_with_percentage="${average_coverage_rounded}%"

# Save to pr_coverage_summary.txt
cat <<EOF > pr_coverage_summary.txt
| ID | Name | Executable Lines | Coverage |
|----|------|-----------------:|---------:|
| 0 | $PROJECT_NAME | $total_lines | **$average_coverage_with_percentage** |
EOF
