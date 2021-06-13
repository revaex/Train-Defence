extends Node2D

export var scroll_speed : float

func _ready():
	$Dirt.material.set_shader_param("speed_scale", scroll_speed)
	$Track.material.set_shader_param("speed_scale", scroll_speed*3)
	return
