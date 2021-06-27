extends Item


func _init():
	self.display_name = "Medic Kit"
	self.type = ItemType.HEALTH
	self.sub_type = ItemSubType.FLAT
	self.data = {
		"value" : 5,
	}
	
