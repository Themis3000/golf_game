extends Node

var base_tilemap = preload("res://level_builder/base_tilemap.tscn")
var layer_names = ["ground", "walls", "goal"]

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
		tilemap.set_name("tilemap_dim" + str(dimension_index))
		for layer in 3:
			var layer_name = layer_names[layer]
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
