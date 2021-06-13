extends Item


func _init():
	self.display_name = "Health Potion"
	self.type = ItemType.HEALTH
	self.value = 3
	

func _ready():
	pass


func _on_ItemHP_body_entered(body):
	picked_up_by(body)
