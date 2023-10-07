const std = @import("std");
const OptimizeMode = std.builtin.OptimizeMode;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = OptimizeMode.ReleaseFast,
    });

    const exe = b.addExecutable(.{
        .name = "fizzbuzz",
        .root_source_file = .{ .path = "fizzbuzz.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());
}
