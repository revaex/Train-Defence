extends Node


export (bool) var can_gain_exp = false
export (int) var level = 1 setget _set_level
var experience = 0 setget _set_experience
var experience_required = get_required_exp(level + 1) setget _set_experience_required
var experience_total = 0 setget _set_experience_total


func get_required_exp(_level):
	return round(pow(_level, 1.8) + _level * 4 + 10)

func gain_experience(value):
	if can_gain_exp:
		self.experience_total += value
		self.experience += value
		while experience >= experience_required:
			self.experience -= experience_required
			level_up()

func level_up():
	self.level += 1
	self.experience_required = get_required_exp(level + 1)

func _set_level(value):
	level = value
	GlobalEvents.emit_signal("update_exp_label")

func _set_experience(value):
	experience = value
	owner.get_node("ExpBar").set_value(value)
	GlobalEvents.emit_signal("update_exp_label")

func _set_experience_required(value):
	experience_required = value
	owner.get_node("ExpBar").set_max_value(value)
	GlobalEvents.emit_signal("update_exp_label")

func _set_experience_total(value):
	experience_total = value
