extends RigidBody2D

var shooter_sprite;
var angle = 0
var power = 0.4
var time_since_shot = 0
var in_shot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#var force = Vector2(80, 20)
	#apply_impulse(force)
	shooter_sprite = get_node("BallSprite/ShooterSprite")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Do physics handling
	time_since_shot += delta
	var velocity = get_linear_velocity()
	var total_velocity = abs(velocity.x) + abs(velocity.y)
	
	# Stop ball if it is moving slow
	if (total_velocity < 3.5) and time_since_shot > 0.75 and in_shot:
		in_shot = false
		shooter_sprite.set_visible(true)
		angle = 0
		power = 0.4
		set_linear_velocity(Vector2(0, 0))
		set_angular_velocity(0)
		set_sleeping(true)
	
	# Do power/angle input handling
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
	if Input.is_action_pressed("shoot") and not in_shot:
		in_shot = true
		time_since_shot = 0
		shooter_sprite.set_visible(false)
		var x = sin(angle) * power * 100
		var y = cos(angle) * power * 100
		var force = Vector2(y, x)
		apply_impulse(force)
