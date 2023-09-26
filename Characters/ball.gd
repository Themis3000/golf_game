extends RigidBody2D

var shooter_sprite
var x_sprite
var area_2d
var angle = 0
var power = 0.4
var time_since_shot = 0
var in_shot = false
var spawnpoint

func dia_shift(new_body, old_body):
	var overlaps_new = area_2d.overlaps_body(new_body)
	var overlaps_old = area_2d.overlaps_body(old_body)
	var is_stuck = overlaps_new and not overlaps_old
	set_stuck(is_stuck)

func set_stuck(is_stuck):
	x_sprite.set_visible(is_stuck)
	set_freeze_enabled(is_stuck)
	if is_stuck:
		set_linear_velocity(Vector2(0, 0))
		set_angular_velocity(0)
		in_shot = false
		shooter_sprite.set_visible(false)
	elif not in_shot:
		shooter_sprite.set_visible(true)

func reset_level():
	set_position(spawnpoint)
	reset_shot()

func reset_shot():
	in_shot = false
	shooter_sprite.set_visible(true)
	angle = 0
	power = 0.4
	set_linear_velocity(Vector2(0, 0))
	set_angular_velocity(0)
	set_sleeping(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	shooter_sprite = get_node("BallSprite/ShooterSprite")
	x_sprite = get_node("BallSprite/xSprite")
	area_2d = get_node("Area2D")
	spawnpoint = get_position()
	SignalManager.dimension_shift.connect(dia_shift)
	SignalManager.restart_level.connect(reset_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Do physics handling
	time_since_shot += delta
	var velocity = get_linear_velocity()
	var total_velocity = abs(velocity.x) + abs(velocity.y)
	
	# Stop ball if it is moving slow and prepare for another shot
	if (total_velocity < 3.5) and time_since_shot > 0.75 and in_shot:
		reset_shot()
	
	# Do power/angle input handling
	if not in_shot and not is_freeze_enabled():
		var power_input = Input.get_action_strength("power_up") - Input.get_action_strength("power_down")
		var angle_input = Input.get_action_strength("angle_down") - Input.get_action_strength("angle_up")
	
		var power_delta = power_input * delta / 3.6
		var angle_delta = angle_input * delta
	
		power += power_delta
		if power > 1:
			power = 1
		elif power < 0.15:
			power = 0.15
		angle += angle_delta
	
		shooter_sprite.set_rotation(angle)
		shooter_sprite.set_scale(Vector2(power, .27))
	
		# Do shot handling
		if Input.is_action_pressed("shoot"):
			in_shot = true
			time_since_shot = 0
			shooter_sprite.set_visible(false)
			var x = sin(angle) * power * 100
			var y = cos(angle) * power * 100
			var force = Vector2(y, x)
			apply_impulse(force)

# Detect hitting goal
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.get_class() != "TileMap":
		return
	var collision_layer = body.get_layer_for_body_rid(body_rid)
	var layer_name = body.get_layer_name(collision_layer)
	if layer_name == "goal":
		SignalManager.goal_reached.emit()
