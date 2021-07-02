extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if OS.is_debug_build():
		GlobalSceneChange.goto_scene("res://scene/Game.tscn", 1.0, "")


func _on_Play_pressed():
	GlobalSceneChange.goto_scene("res://scene/Game.tscn")
