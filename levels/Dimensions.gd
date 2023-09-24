extends Node

var dimensions
var enabled_dimension = 0

func sort_nodes(a: Node, b: Node):
	# Compares last character (hopefully a number to avoid crashes!) in node name.
	var node_a_num = int(a.get_name().right(1))
	var node_b_num = int(b.get_name().right(1))
	return node_a_num < node_b_num

func set_tilemap_enabled(tm: TileMap, enabled: bool):
	tm.set_visible(enabled)
	for layer_num in tm.get_layers_count():
		tm.set_layer_enabled(layer_num, enabled)

func set_dimension(dimension_id: int):
	var old_dimension = dimensions[enabled_dimension]
	var new_dimension = dimensions[dimension_id]
	set_tilemap_enabled(old_dimension, false)
	set_tilemap_enabled(new_dimension, true)
	enabled_dimension = dimension_id

# Called when the node enters the scene tree for the first time.
func _ready():
	dimensions = find_children("*_dim?", "TileMap")
	dimensions.sort_custom(sort_nodes)
	
	for dimension in dimensions:
		set_tilemap_enabled(dimension, false)
	
	set_dimension(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("dim_toggle"):
		if enabled_dimension == 0:
			set_dimension(1)
		else:
			set_dimension(0)
