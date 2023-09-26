extends Node

var base_tilemap = preload("res://level_builder/base_tilemap.tscn")

func deserialize_level(file_name: String, scene: Node2D):
	var path = "user://" + file_name
	var data_string = FileAccess.get_file_as_string(path)
	var data = JSON.parse_string(data_string)
	
	var ball_data = data["ball"]
	var ball = scene.get_node("Ball")
	ball.set_position(Vector2(ball_data["x"], ball_data["y"]))
	
	var dimensions_node = scene.get_node("Dimensions")
	for dimension_index in data["dimensions"].size():
		var dimension_data = data["dimensions"][dimension_index]
		var tilemap: TileMap = base_tilemap.instantiate()
		
		var premade_layers = {}
		for layer_id in tilemap.get_layers_count():
			var layer_name = tilemap.get_layer_name(layer_id)
			premade_layers[layer_name] = layer_id
		
		tilemap.set_name("tilemap_dim" + str(dimension_index))
		for layer_name in dimension_data:
			var layer = premade_layers.get(layer_name, null)
			if layer == null:
				layer = tilemap.get_layers_count() - 1
				tilemap.add_layer(layer)
				tilemap.set_layer_name(layer, layer_name)
			var layer_data = dimension_data[layer_name]
			for x_value in layer_data:
				var cell_datas = layer_data[x_value]
				for y_value in cell_datas:
					var cell_data = cell_datas[y_value]
					tilemap.set_cell(
						layer,
						Vector2(int(x_value), int(y_value)),
						cell_data[0],
						Vector2(cell_data[1], cell_data[2])
					)
		dimensions_node.add_child(tilemap)
