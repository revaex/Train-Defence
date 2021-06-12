extends Area2D


var speed = 600
var damage
var friendly =  false


func _ready():
	pass

func _physics_process(delta):
	position += transform.x * speed * delta


func _on_Projectile_body_entered(body):
	if body.is_in_group("enemies") and friendly == true:
		print("Dealing " + str(damage) + " damage to enemy.")
		body.queue_free()
	if body.is_in_group("character") and friendly == false:
		print("Dealing " + str(damage) + " damage to character.")
	if body.is_in_group("connectors"):
		print("Dealing " + str(damage) + " damage to connector.")
		body.damage(damage)
	if not body.is_in_group("cars"):
		queue_free()
