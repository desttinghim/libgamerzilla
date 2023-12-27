const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "gamerzilla",
        .target = target,
        .optimize = optimize,
    });
    lib.addCSourceFile(.{
        .file = .{ .path = "gamerzilla.c" },
        .flags = &.{},
    });
    lib.linkLibC();
    lib.linkSystemLibrary("curl");
    lib.linkSystemLibrary("jansson");
    lib.addIncludePath(.{ .path = "./" });
    lib.disable_sanitize_c = true; // TODO: remove undefined behavior

    b.installArtifact(lib);

    const gamerzilla_test = b.addExecutable(.{
        .name = "gamerzillatest",
        .target = target,
        .optimize = optimize,
    });
    gamerzilla_test.addCSourceFile(.{
        .file = .{ .path = "gamerzillatest.c" },
        .flags = &.{},
    });
    gamerzilla_test.linkLibrary(lib);
    gamerzilla_test.linkLibC();
    gamerzilla_test.addIncludePath(.{ .path = "./" });
    gamerzilla_test.disable_sanitize_c = true; // TODO: remove undefined behavior

    b.installArtifact(gamerzilla_test);

    const gamerzilla_test_zig = b.addExecutable(.{
        .name = "gamerzillatest",
        .target = target,
        .optimize = optimize,
        .root_source_file = .{ .path = "gamerzillatest.zig" },
    });
    gamerzilla_test_zig.linkLibrary(lib);
    gamerzilla_test_zig.addIncludePath(.{ .path = "./" });

    b.installArtifact(gamerzilla_test_zig);

    const gamerzilla_server = b.addExecutable(.{
        .name = "gamerzillaserver",
        .target = target,
        .optimize = optimize,
    });
    gamerzilla_server.addCSourceFile(.{
        .file = .{ .path = "gamerzillaserver.c" },
        .flags = &.{},
    });
    gamerzilla_server.linkLibrary(lib);
    gamerzilla_server.linkLibC();
    gamerzilla_server.addIncludePath(.{ .path = "./" });
    gamerzilla_server.disable_sanitize_c = true; // TODO: remove undefined behavior

    b.installArtifact(gamerzilla_server);

    const run_server = b.addRunArtifact(gamerzilla_server);
    const run_server_step = b.step("run-server", "Run gamerzilla server");
    run_server_step.dependOn(&run_server.step);

    const run_client = b.addRunArtifact(gamerzilla_test);
    const run_client_step = b.step("run-client", "Run gamerzilla test client (server should be running first)");
    run_client_step.dependOn(&run_client.step);

    const run_client_zig = b.addRunArtifact(gamerzilla_test_zig);
    const run_client_zig_step = b.step("run-client-zig", "Run gamerzilla zig test client (server should be running first)");
    run_client_zig_step.dependOn(&run_client_zig.step);
}
