#!/bin/bash

set -ue -o pipefail

dir=$1
shift

board=$1
shift

display=$1
shift

cd /second-movement/

echo '---- movement_config.h'
cat "${dir}movement_config.h"

echo '---- movement_tunes_config.h'
cat "${dir}movement_tunes_config.h"

# Don't bothering making most of the .o files
for build_dir in "build-${board}_${display}" "build-sim-${board}_${display}"; do
  mkdir -p "$dir$build_dir"
  for f in $build_dir/*.o; do
    ln -s "$(pwd)/$f" "$dir$f"
  done
  # Remove all the *.o that depend on movement_config.h and movement_tunes_config.h
  # so that user settings from the builder UI are properly applied.
  #
  # I experimented with refactoring this out as well, such that changing movement_config.h
  # only affected a couple of functions, but it didn't actually save that much time and
  # required a much larger change to the repo (i.e. not one we want to carry in a patch).
  rm "$dir$build_dir/movement.o"
  rm "$dir$build_dir/movement_custom_signal_tunes.o"
  rm "$dir$build_dir/movement_custom_alarm_tunes.o"
  rm "$dir$build_dir/page_ordering_face.o"
  # The firmware-flasher objects can't stay symlinked into the read-only
  # prebuilt tree: flasher-rules.mk objcopies the RAM-resident TUs in place,
  # and the face/core objects are recompiled whenever patch-backend.flag is
  # (re)created -- both would write through the symlink. Rebuild them fresh.
  rm -f "$dir$build_dir"/firmware_flasher_*.o
done

echo make BUILD="${dir}build-${board}_${display}" MOVEMENT_CONFIG="${dir}movement_config.h" MOVEMENT_TUNES_CONFIG="${dir}movement_tunes_config.h" "$@"
make BUILD="${dir}build-${board}_${display}" MOVEMENT_CONFIG="${dir}movement_config.h" MOVEMENT_TUNES_CONFIG="${dir}movement_tunes_config.h" "$@"
emmake make BUILD="${dir}build-sim-${board}_${display}" MOVEMENT_CONFIG="${dir}movement_config.h" MOVEMENT_TUNES_CONFIG="${dir}movement_tunes_config.h" "$@"
