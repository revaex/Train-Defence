extends Control


func _ready():
	pass


func _on_Play_pressed():
	GlobalSceneChange.goto_scene("res://scene/Game.tscn")
