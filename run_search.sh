#!/bin/bash
# Reproduces logs/search_*.log: runs search.g for all orders 201-1000 (Section 5), in 4 parallel
# processes. Orders with many groups (384, 576, 640, 768, 864, 960) are split into parts.
# Order 768 (1,090,235 groups) takes about 4-5 hours per part. Usage: ./run_search.sh
cd "$(dirname "$0")"
run_job() {
  args="${1%%|*}"; name="${1##*|}"
  echo "$(date '+%F %T') start $name"
  gap -q -c "$args" gap/lib.g gap/search.g < /dev/null 2>&1 | tr -d '\r' > "logs/$name.log"
  echo "$(date '+%F %T') end   $name"
}
export -f run_job
SKIP='skip:=[384,576,640,768,864,896,960];;'
xargs -P 4 -I{} bash -c 'run_job "$@"' _ {} <<JOBS
nmin:=768;; nmax:=768;; ir:=1;; ik:=4;;|search_768_part1of4
nmin:=768;; nmax:=768;; ir:=2;; ik:=4;;|search_768_part2of4
nmin:=768;; nmax:=768;; ir:=3;; ik:=4;;|search_768_part3of4
nmin:=768;; nmax:=768;; ir:=4;; ik:=4;;|search_768_part4of4
nmin:=201;; nmax:=1000;; r:=0;; k:=4;; $SKIP|search_201-1000_r0of4
nmin:=201;; nmax:=1000;; r:=1;; k:=4;; $SKIP|search_201-1000_r1of4
nmin:=201;; nmax:=1000;; r:=2;; k:=4;; $SKIP|search_201-1000_r2of4
nmin:=201;; nmax:=1000;; r:=3;; k:=4;; $SKIP|search_201-1000_r3of4
nmin:=384;; nmax:=384;; ir:=1;; ik:=4;;|search_384_part1of4
nmin:=384;; nmax:=384;; ir:=2;; ik:=4;;|search_384_part2of4
nmin:=384;; nmax:=384;; ir:=3;; ik:=4;;|search_384_part3of4
nmin:=384;; nmax:=384;; ir:=4;; ik:=4;;|search_384_part4of4
nmin:=640;; nmax:=640;; ir:=1;; ik:=4;;|search_640_part1of4
nmin:=640;; nmax:=640;; ir:=2;; ik:=4;;|search_640_part2of4
nmin:=640;; nmax:=640;; ir:=3;; ik:=4;;|search_640_part3of4
nmin:=640;; nmax:=640;; ir:=4;; ik:=4;;|search_640_part4of4
nmin:=576;; nmax:=576;; ir:=1;; ik:=2;;|search_576_part1of2
nmin:=576;; nmax:=576;; ir:=2;; ik:=2;;|search_576_part2of2
nmin:=864;; nmax:=864;; ir:=1;; ik:=2;;|search_864_part1of2
nmin:=864;; nmax:=864;; ir:=2;; ik:=2;;|search_864_part2of2
nmin:=960;; nmax:=960;; ir:=1;; ik:=2;;|search_960_part1of2
nmin:=960;; nmax:=960;; ir:=2;; ik:=2;;|search_960_part2of2
nmin:=896;; nmax:=896;;|search_896
JOBS
