#!/bin/sh

cd second-movement

for tune in $(grep --only-matching 'INCLUDE_ALARM_TUNE_.*' movement_custom_alarm_tunes.c | sort --unique | sed s/INCLUDE_//); do
    echo "<option value=$tune selected>$tune</option>"
done
