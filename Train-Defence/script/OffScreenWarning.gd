extends Node2D

class_name OffScreenWarning

# This should be attached to objects (like cars) that start off-screen

onready var sprite = $Sprite
onready var icon = $Sprite/Icon

func _process(_delta):
	var top_left = -get_canvas_transform().origin / get_canvas_transform().get_scale()
	var size = get_viewport_rect().size / get_canvas_transform().get_scale()
	
	set_warning_position(Rect2(top_left, size))
	set_warning_rotation()

func set_warning_position(rect : Rect2):
	sprite.global_position.x = clamp(global_position.x, rect.position.x, rect.end.x)
	sprite.global_position.y = clamp(global_position.y, rect.position.y, rect.end.y)
	
	if rect.has_point(global_position + owner.get_node("Sprite").texture.get_size()/2):# + Vector2(-10,-10)):
		set_visible(false)
	else:
		set_visible(true)

func set_warning_rotation():
	var angle = (global_position - sprite.global_position).angle()
	sprite.global_rotation = angle
	icon.global_rotation = 0
