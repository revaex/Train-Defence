extends CustomProgressBar

class_name HPBar

func initialize():
	self.bar_max_value = owner.max_hp
	self.bar_value = owner.max_hp
