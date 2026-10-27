#!/bin/sh
# Port of "File finder single and place in folder.bat"

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
    echo "copy failed: $fileID.png (figure)" >&2
cp -- "$PWD/allequipmenticons/$fileID.png"   "$PWD/1 2 icon/$fileID icon.png"   ||
    echo "copy failed: $fileID.png (icon)" >&2

printf 'Press Enter to continue...'
read -r _
