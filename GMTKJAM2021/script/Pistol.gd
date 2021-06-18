extends Gun

func _init():
	self.damage = 1
	self.reload_time = 0.5
	self.projectile = "res://scene/projectiles/Projectile.tscn"
	self.display_name = "Pistol"
	self.type = ItemType.GUN


func _on_Pistol_body_entered(body):
	if not picked_up:
		picked_up_by(body)
