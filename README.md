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

## Table of Optimizations

| #   | Description           | `n`           | Average   |
| --- | --------------------- | ------------- | --------- |
| 0   | naive implementation | `100_000_000` | 9.89MiB/s |

**Baseline**: `/dev/zero pv > /dev/null` is 34.6GiB/s
