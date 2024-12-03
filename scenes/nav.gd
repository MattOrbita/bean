extends TileMapLayer
var NoNav = Vector2i(0, 0)
var YesNav = Vector2i(1, 0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func removeNav(tile_pos: Vector2i) -> void:
	set_cell(tile_pos, 0, NoNav, 0)
	
func addNav(tile_pos: Vector2i) -> void:
	set_cell(tile_pos, 0, YesNav, 0)
