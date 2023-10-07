const std = @import("std");

pub fn main() !void {
    const writer = std.io.getStdOut().writer();

    for (0..100_000_000) |i| {
        if (i % 3 == 0 and i % 5 == 0) {
            _ = try writer.write("FizzBuzz\n");
        } else if (i % 3 == 0) {
            _ = try writer.write("Fizz\n");
        } else if (i % 5 == 0) {
            _ = try writer.write("Buzz\n");
        } else {
            _ = try writer.print("{d}\n", .{i});
        }
    }
}
