extends Gun

func _init():
	self.damage = 0.5
	self.firing_rate = 0.15
	self.clip_size = 16
	self.reload_time = 2
	self.total_ammo = self.clip_size * 2
	self.projectile = "res://scene/projectiles/Bullet.tscn"
	self.projectile_speed = 850
	self.display_name = "Machine Gun"
	self.type = ItemType.GUN


