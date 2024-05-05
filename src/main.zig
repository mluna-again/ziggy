const std = @import("std");

var address_buffer: [8]usize = undefined;

var trace1 = std.builtin.StackTrace{
    .instruction_addresses = address_buffer[0..4],
    .index = 0,
};

var trace2 = std.builtin.StackTrace{
    .instruction_addresses = address_buffer[4..],
    .index = 0,
};

fn List(comptime T: type) type {
    return struct {
        items: []T,
        len: usize,
    };
}

pub fn main() void {
    const message = "hello and welcome to my room";
    var iter = std.mem.tokenize(u8, message, " ");
    while (iter.next()) |word| {
        std.debug.print("{s}\n", .{word});
    }

    const file = std.fs.cwd().openFile("build.zig", .{}) catch |err| {
        std.debug.print("err!: {} \n", .{err});
        return;
    };
    _ = file;

    std.debug.captureStackTrace(null, &trace1);
    std.debug.dumpStackTrace(trace1);

    var buffer: [10]i32 = undefined;
    var list = List(i32){
        .items = &buffer,
        .len = 0,
    };
    list.items[0] = 1234;
    list.len += 1;

    return;
}

fn parseInt(buf: []const u8, radix: u8) !u64 {
    var x: u64 = 0;

    for (buf) |char| {
        const digit = try charToDigit(char);
        if (digit >= radix) {
            return error.DigitExceedsRadix;
        }

        x = try std.math.mul(u64, x, radix);
        x = try std.math.add(u64, x, digit);
    }

    return x;
}

fn charToDigit(char: u8) !u8 {
    const value = switch (char) {
        '0'...'9' => char - '0',
        'A'...'Z' => char - 'A' + 10,
        'a'...'z' => char - 'a' + 10,
        else => return error.InvalidCharacter,
    };

    return value;
}

test "100 should be parsed" {
    const result = parseInt("100", 10) catch {
        const stderr = std.io.getStdErr();
        stderr.writeAll("100 could not be parsed for some reason") catch unreachable;
        return;
    };

    std.debug.print("100 parsed to {d}", .{result});
}

const Device = struct {
    name: []u8,
    fn create(alloc: *std.mem.Allocator, id: u32) !Device {
        const dev = try alloc.create(Device);
        errdefer alloc.destroy(dev);

        dev.name = try std.fmt.allocPrint(alloc, "Device(id={d})", id);
        errdefer alloc.free(dev.name);

        if (id == 0) return error.ReservedDeviceId;

        return dev;
    }
};
