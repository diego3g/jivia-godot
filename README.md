# Generate autotile

```
tool
extends TileMap

export (int) var counter = 0
export (bool) var generate_autotile_collision = false

var sprite_sheet_size = Vector2(5, 3)

func _ready():
	if Engine.editor_hint:
		_generate_autotile_collisions()


func _generate_autotile_collisions():
	for x in sprite_sheet_size.x:
		for y in sprite_sheet_size.y:
			var shape = ConvexPolygonShape2D.new()
			
			shape.points = [
				Vector2.ZERO,
				Vector2(0, 16),
				Vector2(16, 16),
				Vector2(16, 0)
			]
			
			tile_set.tile_add_shape(
				0, 
				shape,
				Transform2D(0.0, Vector2.ZERO),
				false,
				Vector2(x, y)
			)

```