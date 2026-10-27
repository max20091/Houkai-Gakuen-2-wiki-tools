#!/bin/sh
# Combine.sh — Linux port of Combine.bat (ImageMagick 7)
# Usage: ./Combine.sh [base-dir]   (default: the folder holding this script)
set -u

BASE=${1:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}
BASE=${BASE%/}
[ -d "$BASE" ] || { echo "ERROR: no such folder: $BASE" >&2; exit 1; }

if   command -v magick  >/dev/null 2>&1; then MAGICK=magick
elif command -v convert >/dev/null 2>&1; then MAGICK=convert
else echo "ERROR: neither 'magick' nor 'convert' in PATH" >&2; exit 1
fi

pick_dir() {   # $1 = preferred name, $2 = lowercase alternative
    if   [ -d "$BASE/$1" ]; then printf '%s' "$BASE/$1"
    elif [ -d "$BASE/$2" ]; then printf '%s' "$BASE/$2"
    else mkdir -p "$BASE/$1" && printf '%s' "$BASE/$1"
    fi
}

IN=$(pick_dir Input  input)
OUT=$(pick_dir Output output)
BG=$(pick_dir Backgrounds backgrounds)

echo "using  : $MAGICK"
echo "input  : $IN"
echo "output : $OUT"
echo "bg     : $BG"
echo

n=0; ok=0; bad=0; skipped=0
for f in "$IN"/*; do
    [ -f "$f" ] || continue
    name=${f##*/}
    lower=$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]')

    # pull N out of "... <N> Star(s) icon.<ext>" — the leading X guarantees
    # there is always a non-digit for the pattern to anchor on.
    count=$(printf 'X%s\n' "$lower" |
            sed -n 's/.*[^0-9]\([0-9][0-9]*\) *stars* *icon\..*/\1/p')

    case "${count:-}" in
        1|2) bg=Green.png  ;;
        3|4) bg=Blue.png   ;;
        5|6) bg=Purple.png ;;
        7)   bg=Gold.png   ;;
        *)   skipped=$((skipped + 1)); continue ;;
    esac
    n=$((n + 1))

    if [ ! -f "$BG/$bg" ]; then
        echo "SKIP   : $name — missing background $BG/$bg" >&2
        bad=$((bad + 1)); continue
    fi

    out=$OUT/${name%.*}.png
    if "$MAGICK" "$BG/$bg" "$f" -gravity center -composite "$out"; then
        echo "ok     : $name  [${count} star]  + $bg  ->  ${name%.*}.png"
        ok=$((ok + 1))
    else
        echo "FAILED : $name" >&2
        bad=$((bad + 1))
    fi
done

echo
echo "$n icon(s) matched: $ok ok, $bad failed; $skipped file(s) ignored"
if [ "$n" -eq 0 ]; then
    echo "NOTE: nothing in $IN looked like '<n> Star(s) icon.<ext>'." >&2
fi

printf '\nPress Enter to close...'
read -r _
