# Fast Fizz Buzz using Zig

`fizzbuzz.zig` generates [fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz)
output. This is piped through [pv](http://www.ivarch.com/programs/pv.shtml) that
measures data throughput. The output is finally piped to `/dev/null`

## Exec-env

```
OS: macOS 13.5.2 22G91 arm64
Shell: zsh 5.9
Terminal: iTerm2
CPU: Apple M1 Pro
Memory: 32768MiB

```

**Baseline**: `/dev/zero pv > /dev/null` is 34.6GiB/s

## Runs

1.  **naive implementation**: `9.89MiB/s`
    - `0:01:10 for 700 MiB (n: 100_000_000) at 9.89MiB/s`
2.  **use `std.c.printf`**: `127MiB/s`
    - `0:00:58 for 7.33 GiB (n: 1_000_000_000) at 127MiB/s`
    - C std lib [`printf`](https://man7.org/linux/man-pages/man3/fprintf.3.html) directly writes to stdout, [`writer.write`](https://github.com/ziglang/zig/blob/d68f39b5412e0aeb59d71c9f676221212261dc8c/lib/std/fs/file.zig#L1157) hits multiple conditionals also probably cause try .
