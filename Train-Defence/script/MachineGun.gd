extends Gun

func _init():
	self.damage = 0.5
	self.firing_time = 0.15
	self.clip_size = 12
	self.reload_time = 2
	self.projectile = "res://scene/projectiles/Bullet.tscn"
	self.projectile_speed = 850
	self.display_name = "Machine Gun"
	self.type = ItemType.GUN


func _on_MachineGun_body_entered(body):
	if not picked_up:
		picked_up_by(body)
