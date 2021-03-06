extends Gun


func _init():
	self.damage = 1
	self.firing_rate = 0.5 # The time between consecutive bullets
	self.clip_size = 6
	self.reload_time = 1.5
	self.total_ammo = self.clip_size * 4
	self.projectile = "res://scene/projectiles/Bullet.tscn"
	self.projectile_speed = 700
	self.display_name = "Pistol"
	self.type = ItemType.GUN


