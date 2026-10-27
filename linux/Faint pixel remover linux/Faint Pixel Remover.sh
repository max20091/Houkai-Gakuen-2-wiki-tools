#!/bin/bash
#
# Trim transparent/blank borders from every image in ./input
# Equivalent to:  magick in.png -bordercolor none -border 1 -fuzz 1% -trim +repage -strip out.png
#
set -u

# Define your input and output directories
INPUT_DIR="./input"
OUTPUT_DIR="./output"

# Create the directories if they do not exist yet
mkdir -p "$INPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Make sure ImageMagick 7 (magick) is available
if ! command -v magick >/dev/null 2>&1; then
    echo "Error: 'magick' (ImageMagick 7) not found in PATH." >&2
    echo "Install it with: sudo apt install imagemagick   (or: brew install imagemagick)" >&2
    exit 1
fi

shopt -s nullglob
processed=0
failed=0

# Loop through all files in the input directory
for FILE_PATH in "$INPUT_DIR"/*; do

    # Check if it's actually a file (and not a sub-directory)
    if [ -f "$FILE_PATH" ]; then

        # Extract only the filename (e.g., "photo.png") and the stem
        FILE_NAME=$(basename "$FILE_PATH")
        FILE_STEM="${FILE_NAME%.*}"

        # Only touch things that look like images (delete this block to process everything)
        case "${FILE_NAME,,}" in
            *.png|*.jpg|*.jpeg|*.gif|*.webp|*.bmp|*.tif|*.tiff|*.tga|*.ppm|*.pgm|*.pnm) ;;
            *) echo "Skipping (not an image): $FILE_NAME"; continue ;;
        esac

        # Define the exact destination path (same filename, output folder)
        OUTPUT_PATH="$OUTPUT_DIR/$FILE_NAME"

        echo "Processing: $FILE_NAME"

        # -----------------------------------------------------------
        # PLACE YOUR PROCESSING COMMAND HERE
        # -border 1 adds a 1px transparent frame so -trim can find the
        # background color even when the image is fully opaque at the edges
        # -fuzz 1% tolerates slight color noise, +repage resets the canvas,
        # -strip drops metadata/profiles.
        if magick "$FILE_PATH" \
                -bordercolor none -border 1 \
                -fuzz 1% -trim +repage \
                -strip \
                "$OUTPUT_PATH"; then
            processed=$((processed + 1))
        else
            echo "  !! Failed: $FILE_NAME" >&2
            failed=$((failed + 1))
        fi
        # -----------------------------------------------------------

    fi
done

echo "Done. Processed: $processed, failed: $failed"
[ "$failed" -eq 0 ] || exit 1
echo "All files processed successfully!"
