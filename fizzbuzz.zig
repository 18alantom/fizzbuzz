const std = @import("std");
const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
});

const count: u64 = 1_000_000_000;

pub fn main() !void {
    var buf: [1_048_576]u8 = undefined;
    _ = c.setvbuf(
        c.__stdoutp,
        &buf,
        c._IOFBF,
        buf.len,
    );

    const template = "%d\n%d\nFizz\n%d\nBuzz\nFizz\n%d\n%d\nFizz\nBuzz\n%d\nFizz\n%d\n%d\nFizzBuzz\n";
    var digits = @Vector(8, u64){ 1, 2, 4, 7, 8, 11, 13, 14 };

    while (digits[7] < count) {
        _ = c.printf(
            template,
            digits[0],
            digits[1],
            digits[2],
            digits[3],
            digits[4],
            digits[5],
            digits[6],
            digits[7],
        );
        digits += @splat(15);
    }

    var i = digits[7] - 15 + 2;
    while (i < count) : (i += 1) {
        if (i % 3 == 0 and i % 5 == 0) {
            _ = c.printf("FizzBuzz\n");
        } else if (i % 3 == 0) {
            _ = c.printf("Fizz\n");
        } else if (i % 5 == 0) {
            _ = c.printf("Buzz\n");
        } else {
            _ = c.printf("%d\n", i);
        }
    }
}
