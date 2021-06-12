extends Item



func _init():
	self.display_name = "Health Potion"
	self.type = ItemType.HEALTH
	self.value = 10
	

func _ready():
	pass


func _on_ItemHP_body_entered(body):
	if body.is_in_group("character"):
		$Item.emit_signal("item_picked_up", self)
		queue_free()
