// https://ziglang.org/documentation/0.12.0/#enum
const std = @import("std");
const rl = @cImport({
    @cInclude("raylib.h");
});

pub fn main() void {
    const width = 800;
    const height = 450;
    rl.InitWindow(width, height, "Test");
    defer rl.CloseWindow();

    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.RAYWHITE);
        rl.DrawText("HI ;(", 190, 200, 20, rl.GRAY);
        switch (handle_input()) {
            .noop => {},
            .exit => break,
        }
    }
}

const Op = enum {
    noop,
    exit
};

fn handle_input() Op {
    if (rl.IsKeyDown(rl.KEY_C) and rl.IsKeyDown(rl.KEY_LEFT_CONTROL)) {
        return Op.exit;
    }

    return Op.noop;
}
