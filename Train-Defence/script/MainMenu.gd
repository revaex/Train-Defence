extends Control


func _ready():
	GlobalAudio.stop_all()
#	if OS.is_debug_build():
#		GlobalSceneChange.goto_scene(GlobalSceneChange.scenes.Game, 1.0, "")


func _on_Play_pressed():
	GlobalSceneChange.goto_scene(GlobalSceneChange.scenes.Game)


func _on_Options_pressed():
	GlobalSceneChange.goto_scene(GlobalSceneChange.scenes.Options)
