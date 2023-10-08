const std = @import("std");
const pow = std.math.pow;
const count = 1_000_000_000;

pub fn main() !void {
    var buf: [4_194_304]u8 = undefined;
    var dbuf: [16]u8 = undefined;
    var bw = BufferedWriter.init(&buf);

    for (1..count) |i| {
        if (i % 3 == 0 and i % 5 == 0) {
            bw.write("FizzBuzz\n");
        } else if (i % 3 == 0) {
            bw.write("Fizz\n");
        } else if (i % 5 == 0) {
            bw.write("Buzz\n");
        } else {
            bw.write(fmtDigits(&dbuf, i));
        }
    }
    bw.flush();
}

/// Based off of Int formatting from Zig source code
/// located in src/std/fmt.zig.
///
/// Probably faster cause:
/// - Larger numbers are copied in 2s (`digits2`).
/// - Doesn't use log10 (unsure).
fn fmtDigits(buf: []u8, n: usize) []u8 {
    var index: usize = buf.len - 1;
    var a = n;
    while (a >= 100) : (a = @divTrunc(a, 100)) {
        index -= 2;
        buf[index..][0..2].* = digits2(@as(usize, @intCast(a % 100)));
    }

    if (a < 10) {
        index -= 1;
        buf[index] = '0' + @as(u8, @intCast(a));
    } else {
        index -= 2;
        buf[index..][0..2].* = digits2(@as(usize, @intCast(a)));
    }

    buf[buf.len - 1] = '\n';
    return buf[index..];
}

fn digits2(value: usize) [2]u8 {
    return ("0001020304050607080910111213141516171819" ++
        "2021222324252627282930313233343536373839" ++
        "4041424344454647484950515253545556575859" ++
        "6061626364656667686970717273747576777879" ++
        "8081828384858687888990919293949596979899")[value * 2 ..][0..2].*;
}

const BufferedWriter = struct {
    idx: usize,
    rem: usize,
    buf: [:0]u8,

    const Self = @This();

    pub fn init(buf: []u8) Self {
        const last = buf.len - 1;

        buf[last] = 0;
        const sbuf = buf[0..last :0];

        return .{
            .idx = 0,
            .buf = sbuf,
            .rem = sbuf.len,
        };
    }

    pub fn write(self: *Self, str: []const u8) void {
        var str_idx: usize = 0;
        var str_rem: usize = str.len;

        while (str_rem > 0) {
            const min = @min(str_rem, self.rem);
            @memcpy(
                self.buf[self.idx..(self.idx + min)],
                str[str_idx..(str_idx + min)],
            );

            str_rem -= min;
            self.rem -= min;

            self.idx += min;
            str_idx += min;

            if (self.rem == 0) {
                self.flush();
            }
        }
    }

    pub fn flush(self: *Self) void {
        if (self.rem != 0) {
            self.buf[self.idx] = 0;
        }

        _ = std.c.printf(self.buf);
        self.idx = 0;
        self.rem = self.buf.len;
    }
};
