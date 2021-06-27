extends Item


func _init():
	self.display_name = "Medic Kit (Max HP)"
	self.type = ItemType.HEALTH
	self.sub_type = ItemSubType.MAX
	self.data = {
		"value" : 4,
	}

