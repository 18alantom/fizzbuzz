const std = @import("std");

pub fn main() !void {
    for (0..1000_000_000) |i| {
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
