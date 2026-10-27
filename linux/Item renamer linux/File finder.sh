#!/bin/sh

[ -d "./allequipmentfigures" ] || echo "allequipmentfigures not found"
[ -d "./allequipmenticons" ] || echo "allequipmenticons not found"

echo "Enter file ID with keyboard."
printf "Enter file ID: "
read fileID

cp "./allequipmentfigures/$fileID.png" "./$fileID figure.png"
cp "./allequipmenticons/$fileID.png"   "./$fileID icon.png"

fileID=$((fileID + 1))

cp "./allequipmentfigures/$fileID.png" "./$fileID figure.png"
cp "./allequipmenticons/$fileID.png"   "./$fileID icon.png"

printf "Press Enter to continue . . . "
read _dummy
