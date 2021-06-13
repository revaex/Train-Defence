extends Gun

func _init():
	self.damage = 10
	self.reload_time = 4
	self.projectile = "res://scene/entities/Rocket.tscn"
	self.display_name = "Rocket Launcher"
	self.type = ItemType.GUN
	return


func _on_RocketLauncher_body_entered(body):
	if not picked_up:
		picked_up_by(body)
