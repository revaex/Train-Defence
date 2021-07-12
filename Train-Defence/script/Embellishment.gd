extends Sprite

var texture_dict = {
	1:"res://assets/sprite/environment/rock1.png",
	2:"res://assets/sprite/environment/rock2.png",
	3:"res://assets/sprite/environment/shrub1.png",
	4:"res://assets/sprite/environment/cactus.png"
}

onready var speed = get_parent().scroll_speed

func _ready():
	position.y = randomize_y_position()
	scale = randomize_scale()
	texture = load(randomize_texture())
	rotation_degrees = randomize_rotation()

func _process(delta):
	global_position.x -= speed * delta
	
	if position.x <= -100:
		queue_free()

func randomize_y_position():
	var y_pos : float
	if (randi() % 2 + 1) == 1:
		y_pos = rand_range(-100,-200)
	else:
		y_pos = rand_range(100,200)
	return y_pos

func randomize_scale():
	var scale = rand_range(0.6, 1.6)
	return Vector2(scale, scale)

func randomize_texture():
	var texture_key = (randi() % texture_dict.size() + 1)
	return texture_dict.get(texture_key)
	
func randomize_rotation():
	var rot : float
	rot = rand_range(0, 360)
	return rot
