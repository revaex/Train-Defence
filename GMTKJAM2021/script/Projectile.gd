extends Area2D


signal hit(projectile)

var speed = 600
var damage
var friendly =  false


func _ready():
	if friendly:
		set_collision_mask_bit(5, true)

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_Projectile_body_entered(body):
	
	if body.is_in_group("enemies") and friendly == true:
		print("Dealing " + str(damage) + " damage to enemy.")
# warning-ignore:return_value_discarded
		connect("hit", body, "_on_Projectile_hit")
		emit_signal("hit", self)
		
	elif body.is_in_group("character") and friendly == false:
		print("Dealing " + str(damage) + " damage to character.")
# warning-ignore:return_value_discarded
		connect("hit", body, "_on_Projectile_hit")
		emit_signal("hit", self)
		
	if body.is_in_group("connectors") and friendly == false:
		print("Dealing " + str(damage) + " damage to connector.")
# warning-ignore:return_value_discarded
		connect("hit", body, "_on_Projectile_hit")
		emit_signal("hit", self)
		
	if not body.is_in_group("cars"):
		queue_free()
