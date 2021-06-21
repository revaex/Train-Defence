extends Projectile


func _ready():
	pass

func _on_Rocket_body_entered(body):
	hit_something(body)
