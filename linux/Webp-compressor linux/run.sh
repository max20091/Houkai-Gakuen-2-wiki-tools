#!/bin/bash

# Define your input and output directories
INPUT_DIR="./input"
OUTPUT_DIR="./output"

# Create the output directory if it does not exist yet
mkdir -p "$INPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Loop through all files in the input directory
for FILE_PATH in "$INPUT_DIR"/*; do

    # Check if it's actually a file (and not a sub-directory)
    if [ -f "$FILE_PATH" ]; then

        # Extract only the filename (e.g., "document.txt")
        FILE_NAME=$(basename "$FILE_PATH")

        # (Optional) Extract name without extension if needed
        FILE_STEM="${FILE_NAME%.*}"

        # Define the exact destination path
        OUTPUT_PATH="$OUTPUT_DIR/$FILE_NAME"

        echo "Processing: $FILE_NAME"

        # -----------------------------------------------------------
        # PLACE YOUR PROCESSING COMMAND HERE
        # Example 1: Copying file (Placeholder)
        # cp "$FILE_PATH" "$OUTPUT_PATH"
        cwebp -lossless -z 9 -mt -print_ssim "$INPUT_DIR/$FILE_STEM.png" -o "$OUTPUT_DIR/$FILE_STEM.webp"
        # Example 2: Compressing a file with gzip
        # gzip -c "$FILE_PATH" > "$OUTPUT_PATH.gz"
        # -----------------------------------------------------------

    fi
done

echo "All files processed successfully!"
