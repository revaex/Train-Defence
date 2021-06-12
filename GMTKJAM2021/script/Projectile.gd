extends Area2D


var speed = 600
var damage


func _ready():
	pass


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_Projectile_body_entered(body):
	if body.is_in_group("enemies"):
		body.queue_free()
	queue_free()
