extends Gun


func _init():
	self.damage = 1
	self.firing_time = 0.5 # The time between consecutive bullets
	self.clip_size = 6
	self.reload_time = 1
	self.projectile = "res://scene/projectiles/Bullet.tscn"
	self.projectile_speed = 700
	self.display_name = "Pistol"
	self.type = ItemType.GUN


func _on_Pistol_body_entered(body):
	if not picked_up:
		picked_up_by(body)
