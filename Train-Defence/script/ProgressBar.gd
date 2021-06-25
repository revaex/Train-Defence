extends Node2D

class_name CustomProgressBar

signal timer_timeout


var bar_max_value = 100 setget _set_bar_max_value
var bar_value = 100 setget _set_bar_value

onready var local_position_in_parent = position

func initialize():
	pass

func _process(_delta):
	self.set_global_rotation(0)
	self.set_global_position(get_parent().global_position + local_position_in_parent)

func _on_Timer_timeout():
	emit_signal("timer_timeout")

func start_tween(duration):
	$Tween.interpolate_property(self, "bar_value", bar_value, bar_max_value, duration, Tween.TRANS_SINE, Tween.EASE_IN)
	$Tween.start()

func set_value(value):
	self.bar_value = value

func set_max_value(value):
	self.bar_max_value = value

func _set_bar_value(value):
	bar_value = value
	$Bar.value = value
	if owner is Character:
		GlobalEvents.emit_signal("bar_value_changed", value, self)

func _set_bar_max_value(value):
	bar_max_value = value
	$Bar.max_value = value
	if owner is Character:
		GlobalEvents.emit_signal("bar_max_value_changed", value, self)
