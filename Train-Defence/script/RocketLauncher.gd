extends Gun

func _init():
	self.damage = 5
	self.firing_rate = 1.25
	self.clip_size = 2
	self.reload_time = 2.5
	self.projectile = "res://scene/projectiles/Rocket.tscn"
	self.projectile_speed = 700
	self.display_name = "Rocket Launcher"
	self.type = ItemType.GUN


func _on_RocketLauncher_body_entered(body):
	if not picked_up:
		picked_up_by(body)
