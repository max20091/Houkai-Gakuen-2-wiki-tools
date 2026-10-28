#!/bin/sh
# Port of "File finder dual and place in folder.bat"

if [ ! -d "$PWD/allequipmentfigures" ]; then
    echo "allequipmentfigures not found"
fi
if [ ! -d "$PWD/allequipmenticons" ]; then
    echo "allequipmenticons not found"
fi

echo "Enter file ID with keyboard."
printf 'Enter file ID: '
IFS= read -r fileID

# Input is used verbatim: no numeric check, no stripping of leading zeros,
# no trimming of whitespace.

cp -- "$PWD/allequipmentfigures/$fileID.png" "$PWD/1 1 item/$fileID figure.png" ||
    echo "copy failed: $fileID.png (figure 1)" >&2
cp -- "$PWD/allequipmenticons/$fileID.png"   "$PWD/1 2 icon/$fileID icon.png"   ||
    echo "copy failed: $fileID.png (icon 1)" >&2

# Second pair: increment, keeping the original width so 007 -> 008.
nextID=$(awk -v id="$fileID" 'BEGIN { printf "%0*d", length(id), id + 1 }')

cp -- "$PWD/allequipmentfigures/$nextID.png" "$PWD/2 1 item/$nextID figure.png" ||
    echo "copy failed: $nextID.png (figure 2)" >&2
cp -- "$PWD/allequipmenticons/$nextID.png"   "$PWD/2 2 icon/$nextID icon.png"   ||
    echo "copy failed: $nextID.png (icon 2)" >&2

printf 'Press Enter to continue...'
read -r _
