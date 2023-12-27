const std = @import("std");
const c = @cImport({
    @cInclude("gamerzilla.h");
});

const Gamerzilla = struct {
    var ally: std.mem.Allocator = undefined;
    var g: c.Gamerzilla = undefined;
    var trophy: [5]c.GamerzillaTrophy = undefined;
    var game_id: c_int = undefined;

    pub fn init(gzilla_allocator: std.mem.Allocator) !void {
        ally = gzilla_allocator;

        c.GamerzillaInitGame(&g);

        g.short_name = try ally.dupeZ(u8, "test");
        g.name = try ally.dupeZ(u8, "Test");
        g.image = try ally.dupeZ(u8, "test.png");
        g.version = 1;
        g.numTrophy = trophy[0..].len;
        g.trophy = trophy[0..].ptr;

        trophy[0].name = try ally.dupeZ(u8, "Win Game");
        trophy[0].desc = try ally.dupeZ(u8, "Won the Game");
        trophy[0].max_progress = 0;
        trophy[0].true_image = try ally.dupeZ(u8, "true.png");
        trophy[0].false_image = try ally.dupeZ(u8, "false.png");

        trophy[1].name = try ally.dupeZ(u8, "Slayer");
        trophy[1].desc = try ally.dupeZ(u8, "Defeat 100 monsters");
        trophy[1].max_progress = 100;
        trophy[1].true_image = try ally.dupeZ(u8, "true.png");
        trophy[1].false_image = try ally.dupeZ(u8, "false.png");

        trophy[2].name = try ally.dupeZ(u8, "Game Master");
        trophy[2].desc = try ally.dupeZ(u8, "Solve 10 puzzles");
        trophy[2].max_progress = 10;
        trophy[2].true_image = try ally.dupeZ(u8, "true.png");
        trophy[2].false_image = try ally.dupeZ(u8, "false.png");

        trophy[3].name = try ally.dupeZ(u8, "Explosive");
        trophy[3].desc = try ally.dupeZ(u8, "Kill 5 enemies in one explosion");
        trophy[3].max_progress = 0;
        trophy[3].true_image = try ally.dupeZ(u8, "true.png");
        trophy[3].false_image = try ally.dupeZ(u8, "false.png");

        trophy[4].name = try ally.dupeZ(u8, "Untouchable");
        trophy[4].desc = try ally.dupeZ(u8, "Defeat boss without taking damage");
        trophy[4].max_progress = 0;
        trophy[4].true_image = try ally.dupeZ(u8, "true.png");
        trophy[4].false_image = try ally.dupeZ(u8, "false.png");

        _ = c.GamerzillaStart(false, "./");

        game_id = c.GamerzillaSetGame(&g);
        _ = c.GamerzillaSetTrophy(game_id, "Slayer");
        _ = c.GamerzillaSetTrophyStat(game_id, "Game Master", 2);
        c.GamerzillaQuit();
    }

    pub fn deinit() void {
        c.GamerzillaQuit();
        for (trophy) |t| {
            ally.free(std.mem.span(@as([*:0]u8, @ptrCast(t.name))));
            ally.free(std.mem.span(@as([*:0]u8, @ptrCast(t.desc))));
            ally.free(std.mem.span(@as([*:0]u8, @ptrCast(t.true_image))));
            ally.free(std.mem.span(@as([*:0]u8, @ptrCast(t.false_image))));
        }
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    try Gamerzilla.init(gpa.allocator());
    defer Gamerzilla.deinit();
}
