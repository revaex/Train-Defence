extends Area2D


var speed = 600
var damage


func _ready():
	pass


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_Projectile_body_entered(body):
	if body.is_in_group("enemies"):
		print("Dealing " + str(damage) + " damage to enemy.")
		body.queue_free()
	if body._is_in_group("connectors"):
		print("Dealing " + str(damage) + " damage to connector.")
		body.queue_free()
	if body.is_in_group("character"):
		print("Dealing " + str(damage) + " damage to character.")

	queue_free()
