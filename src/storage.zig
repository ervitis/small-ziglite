const std = @import("std");
const testing = std.testing;

// Storage class to handle io operations:
// close, write, read
const DBStorage = struct {
    const Self = @This();

    pub fn init() Self {
        return Self{};
    }

    pub fn open(_: *const Self, name: []const u8) !std.fs.File {
        return std.fs.cwd().createFile(name, .{
            .read = true,
        });
    }

    pub fn close(_: *const Self, f: std.fs.File) void {
        f.close();
    }

    pub fn write(_: *const Self, f: std.fs.File, data: []const u8) !void {
        try f.writeAll(data);
    }

    pub fn read(_: *const Self, f: std.fs.File) ![]u8 {
        try f.seekTo(0);
        var buffer: [100]u8 = undefined;
        const n = try f.readAll(buffer[0..]);
        std.debug.print("buf: {s}\n", .{buffer[0..n]});
        return buffer[0..n];
    }
};

test "Storage" {
    const storage = DBStorage.init();

    const f = try storage.open("test01");
    defer storage.close(f);
    var n = try storage.read(f);
    try storage.write(f, "hello world");
    n = try storage.read(f);

    try testing.expect(n.len > 0);
}
