extends CustomProgressBar

class_name AmmoBar


func initialize():
	self.bar_max_value = owner.clip_size
	self.bar_value = owner.current_weapon.clip_size

func set_value(value):
	GlobalEvents.emit_signal("update_ammo_label")
	.set_value(value)
