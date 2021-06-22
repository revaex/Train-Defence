extends Node2D

signal timer_timeout

onready var local_position_in_parent = position

func _process(_delta):
	self.set_global_rotation(0)
	self.set_global_position(get_parent().global_position + local_position_in_parent)


func _on_Timer_timeout():
	emit_signal("timer_timeout")
