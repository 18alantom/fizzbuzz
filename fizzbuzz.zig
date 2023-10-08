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

pub fn fmtDigits(buf: []u8, n: usize) [:0]u8 {
    const fl: f32 = @floatFromInt(n);
    var num_digits: usize = undefined;
    if (n == 0 or n == 1) {
        num_digits = 1;
    } else {
        num_digits = @intFromFloat(@ceil(@log10(fl)));
    }

    var d = n;
    for (0..(num_digits)) |i| {
        const m: u8 = @intCast(@mod(d, 10));
        buf[num_digits - i - 1] = m + 48;
        d /= 10;
    }

    buf[num_digits] = '\n';
    buf[num_digits + 1] = 0;
    return buf[0..(num_digits + 1) :0];
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
