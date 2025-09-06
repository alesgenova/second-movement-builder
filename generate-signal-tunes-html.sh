#!/bin/sh

cd second-movement

for tune in $(grep --only-matching 'INCLUDE_SIGNAL_TUNE_.*' movement_custom_signal_tunes.c | sort --unique | sed s/INCLUDE_//); do
    echo "<option value=$tune selected>$tune</option>"
done
