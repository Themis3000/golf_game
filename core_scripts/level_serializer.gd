extends Node

func serialize_level(path: String, scene: Node2D):
	var data = {}
	
	var ball = scene.get_node("Ball")
	var ball_position = ball.get_position()
	var ball_data = {"x": ball_position.x, "y": ball_position.y}
	data["ball"] = ball_data
	
	var dimensions_node = scene.get_node("Dimensions")
	var dimensions_data = []
	for tilemap_id in dimensions_node.dimensions.size():
		var tilemap = dimensions_node.dimensions[tilemap_id]
		var layers = {}
		for layer_id in tilemap.get_layers_count():
			var layer_name = tilemap.get_layer_name(layer_id)
			var used_cells = tilemap.get_used_cells(layer_id)
			var layer_tile_data = {}
			for pos in used_cells:
				var source_id = tilemap.get_cell_source_id(layer_id, pos)
				var atlas_cords = tilemap.get_cell_atlas_coords(layer_id, pos)
				if pos.x not in layer_tile_data:
					layer_tile_data[pos.x] = {}
				layer_tile_data[pos.x][pos.y] = [source_id, atlas_cords.x, atlas_cords.y]
			layers[layer_name] = layer_tile_data
		dimensions_data.append({
			"ground": layers["ground"],
			 "walls": layers["walls"],
			 "goal": layers["goal"]})
	data["dimensions"] = dimensions_data
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_line(JSON.stringify(data))
