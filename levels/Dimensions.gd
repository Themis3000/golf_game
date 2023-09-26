extends Node

var dimensions
var enabled_dimension = 0
var tilesets = []

func sort_nodes(a: Node, b: Node):
	# Compares last character (hopefully a number to avoid crashes!) in node name.
	var node_a_num = int(a.get_name().right(1))
	var node_b_num = int(b.get_name().right(1))
	return node_a_num < node_b_num

func set_tilemap_enabled(tm: TileMap):
	tm.set_visible(true)
	var tileset = tm.get_tileset()
	var layer1_mask_id = tileset.get_meta("layer1_mask_id", false)
	if layer1_mask_id:
		var layer1_mask = instance_from_id(layer1_mask_id)
		tm.set_tileset(layer1_mask)

func set_tilemap_disabled(tm: TileMap):
	tm.set_visible(false)
	var tileset = tm.get_tileset()
	var layer2_mask_id = tileset.get_meta("layer2_mask_id", false)
	if layer2_mask_id:
		var layer2_mask = instance_from_id(layer2_mask_id)
		tm.set_tileset(layer2_mask)

func set_dimension(dimension_id: int):
	var old_dimension = dimensions[enabled_dimension]
	var new_dimension = dimensions[dimension_id]
	set_tilemap_disabled(old_dimension)
	set_tilemap_enabled(new_dimension)
	enabled_dimension = dimension_id
	SignalManager.dimension_shift.emit(new_dimension, old_dimension)

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.restart_level.connect(reset_dimension)
	dimensions = find_children("*_dim?", "TileMap")
	dimensions.sort_custom(sort_nodes)
	
	# Yes, this is a somewhat strange way of doing things. It was fun though.
	for dimension in dimensions:
		var tileset = dimension.get_tileset()
		var duplicate_tileset = tileset.duplicate(8)
		tileset.set_meta("layer2_mask_id", duplicate_tileset.get_instance_id())
		duplicate_tileset.set_meta("layer1_mask_id", tileset.get_instance_id())
		duplicate_tileset.set_physics_layer_collision_layer(0, 2)
		tilesets.append_array([tileset, duplicate_tileset])
		set_tilemap_disabled(dimension)
	
	set_dimension(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("dim_toggle"):
		if enabled_dimension == 0:
			set_dimension(1)
		else:
			set_dimension(0)

func reset_dimension():
	set_dimension(0)
