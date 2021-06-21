extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Play_pressed():
	GlobalSceneChange.goto_scene("res://scene/Game.tscn")
