const std = @import("std");

const count: u64 = 1_000_000_000;

pub fn main() !void {
    const template = "%d\n%d\nFizz\n%d\nBuzz\nFizz\n%d\n%d\nFizz\nBuzz\n%d\nFizz\n%d\n%d\nFizzBuzz\n";
    var digits = @Vector(8, u64){ 1, 2, 4, 7, 8, 11, 13, 14 };

    while (digits[7] < count) {
        _ = std.c.printf(
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
            _ = std.c.printf("FizzBuzz\n");
        } else if (i % 3 == 0) {
            _ = std.c.printf("Fizz\n");
        } else if (i % 5 == 0) {
            _ = std.c.printf("Buzz\n");
        } else {
            _ = std.c.printf("%d\n", i);
        }
    }
}
