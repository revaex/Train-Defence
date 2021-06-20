extends Gun

func _init():
	self.damage = 4
	self.reload_time = 2
	self.projectile = "res://scene/projectiles/Rocket.tscn"
	self.display_name = "Rocket Launcher"
	self.type = ItemType.GUN


func _on_RocketLauncher_body_entered(body):
	if not picked_up:
		picked_up_by(body)
