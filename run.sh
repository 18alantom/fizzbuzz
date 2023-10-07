#! /bin/sh

zig build && ./zig-out/bin/fizzbuzz | pv -batrm 60 > /dev/null