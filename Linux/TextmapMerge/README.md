# textmapmerge

Merge the game's sharded `TextMap` tables into one file per table that Excel can
import directly.

```bash
./merge.sh            # merge into output/*.txt
./merge.sh --tsv      # also write *.tsv (pastes straight into Excel)
./merge.sh --help
```

Requires only `bash` and standard coreutils. On Windows, run it from Git Bash or
WSL.

This folder only merges. Building the reader itself is a separate set of scripts
in `../hg2-story-reader-web/tools/` — `build_data.py`, `build_names.py`,
`populate_names.py`, `data_all_textasset.py` — documented in
[`../hg2-story-reader-web/README.md`](../hg2-story-reader-web/README.md#tools).

## The problem it solves

The game ships `TextMap` split into numbered shards. Each shard repeats the same
4 header lines:

```
TEXT_ID	CONTENT	Comment
编号	内容	备注
Client	Client	Client
int	string	string
```

`Textmap merge.bat` was:

```bat
for %%f in ("%CD%\input\*.txt") do type "%%f" >> output.txt
```

That is a plain `cat`, so it appends **every shard's 4 header lines** into the
middle of the file. Merging 60 shards leaves 240 stray header rows spread
through the data — Excel shows them as rows, and any lookup on the id column hits
a row containing `TEXT_ID` instead of a number.

This script writes the header **once**, then only the data rows.

## Files read and written

Input is `input/`, output goes to `output/`.

| input | shards | output | data rows |
|---|---|---|---|
| `TextMap_0.txt` … `TextMap_59.txt` | 60 | `TextMap_merged.txt` | 299,756 |
| `TextMapForStory_0.txt` … `_9.txt` | 10 | `TextMapForStory_merged.txt` | 48,514 |
| both families | 70 | `TextMap_mergedall.txt` | 348,270 |

`TextMap_mergedall.txt` is the two tables end to end under a single header. The
two id sets do not overlap, so no row is duplicated, and the split is natural:
`TextMap` stops before id `100000000` with a placeholder row that literally reads
"100000001 onward are ids for textmapforstory". Shards are still excluded —
only the 70 data shards are merged.

Both outputs start with 4 header lines followed by the data, so each is **one
clean table**. Line endings are CRLF and the encoding is UTF-8, matching the
input, so Excel opens them without an import wizard.

`*_DivideConfig.txt` files are **not merged** — they are shard index ranges, not
table rows. For example `0<TAB>221<TAB>14188` means shard 0 holds rows 221 to
14188. Merging them would corrupt the table.

## Why there are three outputs

`TextMap` and `TextMapForStory` have **different column counts**: 3 fields per
data row for `TextMap`, 4 for `TextMapForStory`. So each family gets its own
file, and each is a perfectly rectangular table.

`TextMap_mergedall.txt` combines them for searching across both at once. Use it
when you want to grep or scroll everything together; use the per-family files
when you need a strict column layout.

The two headers are compatible (the extra tabs on `TextMapForStory`'s 4th header
line are padding only), so the combined file keeps the 3-column header and the
wider rows simply carry one extra field. That raggedness is inherent to the
source data, not a merge artifact.

## What the script checks

`merge.sh` reads the shard list, sorts it **numerically** (so `TextMap_2` comes
before `TextMap_10`, which a plain glob gets wrong), takes the 4 header lines
from the first shard, and appends only data from every shard after that.

It then reports the merged row count and warns if it does not match the sum of
the input shards. Expect output like:

```
merging input ...
    TextMap_0.txt                    5000 rows
    ...
    TextMap_59.txt                   4756 rows
  TextMap: 60 shards, 299756 data rows -> output/TextMap_merged.txt
  ...
done. Header written once per file:
  TextMapForStory_merged.txt         4 header rows + 48514 data rows
  TextMap_merged.txt                 4 header rows + 299756 data rows
```

## Verifying a merge

```bash
# exactly one header block, on line 1
grep -n "TEXT_ID" output/TextMap_merged.txt

# every data row has the same field count
tail -n +5 output/TextMap_merged.txt | awk -F'\t' '{print NF}' | sort -u
# -> 3

# rows in == rows out
tail -n +5 output/TextMap_merged.txt | wc -l
# -> 299756

# the combined file has no repeated ids
tail -n +5 output/TextMap_mergedall.txt | cut -f1 | sort | uniq -d | wc -l
# -> 0
```

Shard boundaries line up with `TextMap_DivideConfig.txt`, so the merged file is
a continuous id range: shard 0 ends at `14188` and shard 1 begins at `14189`.

## Changing the shard layout

`HEADER_LINES=4` near the top of `merge.sh` sets how many lines each shard uses
as its header. If a future table uses a different count, change it there.
