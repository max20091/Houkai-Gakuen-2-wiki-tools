#!/usr/bin/env bash
# Merge the sharded TextMap files into one Excel-importable table.
#
#   textmapmerge/
#     merge.sh
#     input/    TextMap_0..59.txt, TextMapForStory_0..9.txt (+ *_DivideConfig.txt)
#     output/   written here
#
# WHY THE HEADERS MATTER
#   Every shard begins with the same 4 header lines (TEXT_ID / 编号 / Client /
#   int). A plain `cat` -- what Textmap merge.bat did -- repeats those 4 lines
#   once per shard, so the merged file has 60+ stray header rows in the middle
#   and Excel shows them as data. This script writes the header ONCE and then
#   only the data rows.
#
#   The two families have DIFFERENT widths (TextMap has 3 columns, TextMapForStory
#   has 8), so they are merged into separate outputs -- mixing them would give a
#   ragged table Excel refuses to parse cleanly.
#
#   *_DivideConfig.txt are index ranges, not tables; they are NOT merged.
#
# Output is written with CRLF line endings and UTF-8, matching the input, so
# Excel opens it directly.
#
#   ./merge.sh              # merge TextMap + TextMapForStory
#   ./merge.sh --tsv        # also write .tsv (pastes straight into Excel)
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IN="${HERE}/input"
OUT="${HERE}/output"
HEADER_LINES=4
ALSO_TSV=0

for a in "$@"; do
    case "$a" in
        --tsv) ALSO_TSV=1 ;;
        -h|--help) sed -n '2,32p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "unknown option: $a" >&2; exit 2 ;;
    esac
done

if [ ! -d "$IN" ]; then
    echo "error: no input/ folder beside merge.sh" >&2
    exit 1
fi
mkdir -p "$OUT"

# shard files of one family, in numeric order (TextMap_2 before TextMap_10)
shards_of() {
    local stem="$1" f
    for f in "$IN/${stem}_"*.txt; do
        [ -e "$f" ] || continue
        case "$(basename "$f")" in *DivideConfig*) continue ;; esac
        printf '%s\n' "$f"
    done | sort -t_ -k2,2n
}

# merge <stem> <output-base> [--keep-blank-id]
merge_family() {
    local stem="$1" base="$2"
    local files total=0 first=1 f n=0
    mapfile -t files < <(shards_of "$stem")

    if [ "${#files[@]}" -eq 0 ]; then
        echo "  ${stem}: no shards found, skipped"
        return 0
    fi

    local tmp
    tmp="$(mktemp)"
    for f in "${files[@]}"; do
        # header once, from the first shard
        if [ "$first" -eq 1 ]; then
            head -n "$HEADER_LINES" "$f" >> "$tmp"
            first=0
        fi
        # data rows only; tail keeps the trailing newline behaviour simple
        tail -n +"$((HEADER_LINES + 1))" "$f" >> "$tmp"
        n=$(( $(wc -l < "$f") - HEADER_LINES ))
        total=$((total + n))
        printf '    %-28s %8d rows\n' "$(basename "$f")" "$n"
    done

    # normalise to CRLF and make sure the file ends with exactly one newline
    sed -e 's/\r$//' -e 's/$/\r/' "$tmp" > "${OUT}/${base}.txt"
    rm -f "$tmp"

    local merged_rows=$(( $(wc -l < "${OUT}/${base}.txt") - HEADER_LINES ))
    echo "  ${stem}: ${#files[@]} shards, ${merged_rows} data rows -> output/${base}.txt"

    if [ "$merged_rows" -ne "$total" ]; then
        echo "    WARNING: expected ${total} rows, got ${merged_rows}" >&2
    fi

    if [ "$ALSO_TSV" -eq 1 ]; then
        sed -e 's/\r$//' -e 's/$/\r/' "${OUT}/${base}.txt" > "${OUT}/${base}.tsv"
        echo "    also wrote output/${base}.tsv"
    fi
}

echo "merging $(basename "$IN") ..."
merge_family "TextMap"          "TextMap_merged"
merge_family "TextMapForStory"  "TextMapForStory_merged"

# ---------------------------------------------------------------- combined
# One table holding BOTH families. Their headers are compatible (the extra tabs
# on TextMapForStory's 4th header line are padding only) and the two id sets do
# not overlap, so this is a straight header + two data blocks.
COMBINED="${OUT}/TextMap_mergedall.txt"
{
    head -n "$HEADER_LINES" "${OUT}/TextMap_merged.txt"
    tail -n +"$((HEADER_LINES + 1))" "${OUT}/TextMap_merged.txt"
    tail -n +"$((HEADER_LINES + 1))" "${OUT}/TextMapForStory_merged.txt"
} | sed -e 's/\r$//' -e 's/$/\r/' > "$COMBINED"
echo "  combined: TextMap_mergedall.txt"

echo
echo "done. Header written once per file:"
for f in "$OUT"/*.txt; do
    [ -e "$f" ] || continue
    printf '  %-34s %s header rows + %s data rows\n' \
        "$(basename "$f")" "$(head -n "$HEADER_LINES" "$f" | wc -l)" \
        "$(( $(wc -l < "$f") - HEADER_LINES ))"
done
