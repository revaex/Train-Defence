extends Item


func _init():
	self.display_name = "Medic Kit (Regen)"
	self.type = ItemType.HEALTH
	self.sub_type = ItemSubType.REGEN
	self.data = {
		"value" : 2,
		"ticks" : 4,
		"tick_time" : 2,
	}

