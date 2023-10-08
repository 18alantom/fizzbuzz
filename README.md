# Fast Fizz Buzz using Zig

`fizzbuzz.zig` generates [fizz buzz](https://en.wikipedia.org/wiki/Fizz_buzz)
output. This is piped through [pv](http://www.ivarch.com/programs/pv.shtml) to
measure data throughput. The output is finally piped to `/dev/null`.

This code aims to maximize fizz buzz data throughput.

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

_Note: reasoning is mostly a guess._

1.  **naive implementation**: `9.89MiB/s` [src](https://github.com/18alantom/fizzbuzz/blob/173578984cae2e13f3f3f3a5dd4369926d96b84a/fizzbuzz.zig)
    - `0:01:10 for 700 MiB (n: 100_000_000) at 9.89MiB/s`
2.  **use `std.c.printf`**: `127MiB/s`
    - `0:00:58 for 7.33 GiB (n: 1_000_000_000) at 127MiB/s` [src](https://github.com/18alantom/fizzbuzz/blob/62fbe6c14ece93f747061e9afb6705a073f78c60/fizzbuzz.zig)
    - C std lib [`printf`](https://man7.org/linux/man-pages/man3/fprintf.3.html) directly writes to stdout, [`writer.write`](https://github.com/ziglang/zig/blob/d68f39b5412e0aeb59d71c9f676221212261dc8c/lib/std/fs/file.zig#L1157) consists of several comparisons, and might return errors which pulls in `builtin.returnError`.
3.  **use buffered writer, faster custom int formatter**: `192MiB/s` [src](https://github.com/18alantom/fizzbuzz/blob/845f435d12495149a0bf72940dca5d61e30678a7/fizzbuzz.zig)
    - `0:00:38 for 7.33 GiB (n: 1_000_000_000) at 192MiB/s`
    - Consists of 2 improvements:
      1. Used a buffered writer which writes output to a 4MB buffer before flushing it to
         stdout using `c.printf`. The buffer size was based off of [this experiment](https://gist.github.com/18alantom/fac21902a1e7b295cac16f3772f42df3#file-fast_zeros-zig) which is probably
         still not optimized for whatever lies between printf invocation and stdout receiving
         the bytes. But it's still better than calling printf for every line of output.
      2. Used a custom int formatter for digit to string conversion. Using
         `fmt.bufPrint` makes it slower than the previous run probably cause
         error handling and call stack.
4.  **??**: `??MiB/s`
