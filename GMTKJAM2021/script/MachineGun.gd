extends Gun

func _init():
	self.damage = 2
	self.reload_time = 0.1
	self.projectile = "res://scene/entities/Projectile.tscn"
	self.display_name = "Machine Gun"
	self.type = ItemType.GUN


func _on_MachineGun_body_entered(body):
	if not picked_up:
		picked_up_by(body)
