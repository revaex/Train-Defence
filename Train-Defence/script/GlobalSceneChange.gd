extends Node


onready var scene_transition = load("res://scene/SceneTransition.tscn").instance()


func _ready():
	pass # Replace with function body.


func goto_scene(path, speed=1.0, animation="fade_black"):
	call_deferred("_deferred_goto_scene", path, speed, animation)


func _deferred_goto_scene(path, speed=1.0, animation="fade_black"):
	self.add_child(scene_transition)
	$SceneTransition/AnimationPlayer.playback_speed = speed
	$SceneTransition/AnimationPlayer.play(animation)
	yield($SceneTransition/AnimationPlayer, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	$SceneTransition/AnimationPlayer.play_backwards(animation)
	yield($SceneTransition/AnimationPlayer, "animation_finished")
	self.remove_child(scene_transition)
	
