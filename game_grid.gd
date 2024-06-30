extends Node2D
class_name GameGrid

const TILE_SIZE = 32
@warning_ignore("integer_division")
const HALF_TILE = TILE_SIZE / 2

func grid_to_world(grid_pos: Vector2i) -> Vector2: return (grid_pos as Vector2) * TILE_SIZE + Vector2.ONE * HALF_TILE

func snap_to_grid(world_pos: Vector2) -> Vector2: return world_pos - world_pos.posmod(TILE_SIZE) + Vector2.ONE * HALF_TILE

func world_to_grid(world_pos: Vector2) -> Vector2i: return Vector2i(world_pos - world_pos.posmod(TILE_SIZE)) / TILE_SIZE

func get_cursor_world() -> Vector2: return snap_to_grid(get_local_mouse_position())

func get_cursor_grid() -> Vector2i: return world_to_grid(get_local_mouse_position())
