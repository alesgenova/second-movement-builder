#!/bin/sh

cd second-movement
commit="$(git rev-parse HEAD)"

for category in clock complication demo io sensor settings; do
    echo "<h3>$category</h3>"
    for f in "watch-faces/$category"/*.h; do
        echo "<option data-category=\"$category\" data-url=\"https://github.com/alesgenova/second-movement/blob/$commit/$f\" value=\"$(basename $f .h)\">$(basename $f _face.h)</option>"
    done
done
