extends CustomProgressBar

class_name ExpBar


func initialize():
	self.bar_max_value = owner.exp_handler.experience_required
	self.bar_value = owner.exp_handler.experience

