#!/bin/sh
# Port of "quick rename.bat"

# --- folder setup ---------------------------------------------------------
# If "2 3 pocket" exists, assume the whole set is already there.
if [ -d "$PWD/2 3 pocket" ]; then
    : # nothing to create
else
    for d in "1 1 item" "1 2 icon" "1 3 pocket" "2 1 item" "2 2 icon" "2 3 pocket"; do
        [ -d "$PWD/$d" ] || mkdir -- "$PWD/$d"
    done
fi

# --- input ----------------------------------------------------------------
echo "Enter file name with keyboard."
printf 'Enter item name: '
IFS= read -r file
printf 'Enter number of stars: '
IFS= read -r star

case "$star" in
    ''|*[!0-9]*)
        echo "Invalid number of stars: must be a whole number" >&2
        exit 1
        ;;
esac
# Normalize leading zeros so "02" doesn't behave like octal later on.
star=$(printf '%s\n' "$star" | sed 's/^0*//')
[ -n "$star" ] || star=0

# --- helpers --------------------------------------------------------------

# Rename the single .png in a folder to a new name.
rename_one() {
    _dir=$1
    _target=$2

    set -- "$_dir"/*.png
    if [ ! -e "$1" ]; then
        echo "no .png found in $_dir, skipping" >&2
        return
    fi
    if [ "$#" -gt 1 ]; then
        echo "warning: several .png in $_dir, renaming only the first" >&2
    fi
    if [ -e "$_dir/$_target" ]; then
        echo "cannot rename: $_dir/$_target already exists" >&2
        return
    fi
    mv -- "$1" "$_dir/$_target"
}

# Move every .png from a folder up into the current directory.
move_all() {
    for f in "$1"/*.png; do
        [ -e "$f" ] || continue
        mv -- "$f" "$PWD/"
    done
}

# --- group 1: folders "1 *", uses the number as entered -------------------
if [ "$star" -lt 2 ]; then
    word="Star"
else
    word="Stars"
fi

rename_one "$PWD/1 1 item"   "$file $star $word.png"
rename_one "$PWD/1 2 icon"   "$file $star $word icon.png"
rename_one "$PWD/1 3 pocket" "$file $star $word pocket.png"

move_all "$PWD/1 1 item"
move_all "$PWD/1 2 icon"
move_all "$PWD/1 3 pocket"

# --- group 2: folders "2 *", always plural, number incremented by one -----
star=$((star + 1))

rename_one "$PWD/2 1 item"   "$file $star Stars.png"
rename_one "$PWD/2 2 icon"   "$file $star Stars icon.png"
rename_one "$PWD/2 3 pocket" "$file $star Stars pocket.png"

move_all "$PWD/2 1 item"
move_all "$PWD/2 2 icon"
move_all "$PWD/2 3 pocket"
