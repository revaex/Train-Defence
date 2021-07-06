extends Node


var experience = 0 setget _set_experience
onready var experience_required = get_required_exp(owner.level + 1) setget _set_experience_required
var experience_total = 0 setget _set_experience_total


func get_required_exp(_level):
	return round(pow(_level, 1.8) + _level * 4 + 10)

func gain_experience(value):
	if owner.can_gain_exp:
		self.experience_total += value
		self.experience += value
		while experience >= experience_required:
			self.experience -= experience_required
			# Level up
			_set_level(owner.level + 1)

func _set_level(value):
	owner.level = value
	self.experience_required = get_required_exp(owner.level + 1)
	if owner is Character:
		GlobalEvents.emit_signal("update_exp_label")

func _set_experience(value):
	experience = value
	owner.get_node("ExpBar").set_value(value)
	if owner is Character:
		GlobalEvents.emit_signal("update_exp_label")

func _set_experience_required(value):
	experience_required = value
	owner.get_node("ExpBar").set_max_value(value)
	if owner is Character:
		GlobalEvents.emit_signal("update_exp_label")

func _set_experience_total(value):
	experience_total = value
