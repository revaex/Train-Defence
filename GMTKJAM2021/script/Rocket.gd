extends Projectile


func _ready():
	if not friendly:
		set_collision_layer_bit(6, false)
		set_collision_layer_bit(8, true)
		set_collision_mask_bit(4, false)
		set_collision_mask_bit(2, true)
		set_collision_mask_bit(3, true)


func _on_Rocket_body_entered(body):
	hit_something(body)
