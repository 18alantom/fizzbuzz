#! /bin/sh

zig build && ./zig-out/bin/fizzbuzz | pv -batrm 5 > /dev/null