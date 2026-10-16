#!/bin/bash
# Reproduces logs/theorems_*.log, logs/question53_*.log and logs/example*.log
# (all the checks for groups of order at most 200, and Examples 5.1 and 5.2),
# in 4 parallel processes. Usage: ./run_checks.sh
cd "$(dirname "$0")"
run_job() {
  args="${1%%|*}"; rest="${1#*|}"; script="${rest%%|*}"; name="${rest##*|}"
  echo "$(date '+%F %T') start $name"
  gap -q -c "$args" gap/lib.g "gap/$script" < /dev/null 2>&1 | tr -d '\r' > "logs/$name.log"
  echo "$(date '+%F %T') end   $name"
}
export -f run_job
xargs -P 4 -I{} bash -c 'run_job "$@"' _ {} <<'JOBS'
nmin:=192;; nmax:=192;; r:=1;; k:=2;;|question53.g|question53_192_part1of2
nmin:=192;; nmax:=192;; r:=2;; k:=2;;|question53.g|question53_192_part2of2
nmin:=192;; nmax:=192;; r:=1;; k:=2;;|theorems.g|theorems_192_part1of2
nmin:=192;; nmax:=192;; r:=2;; k:=2;;|theorems.g|theorems_192_part2of2
nmin:=1;; nmax:=191;;|theorems.g|theorems_1-191
nmin:=193;; nmax:=200;;|theorems.g|theorems_193-200
nmin:=1;; nmax:=191;;|question53.g|question53_1-191
nmin:=193;; nmax:=200;;|question53.g|question53_193-200
|example51.g|example51
|example52.g|example52
|example52_check.g|example52_check
JOBS
