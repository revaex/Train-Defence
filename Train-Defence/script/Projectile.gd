extends Area2D

class_name Projectile


signal hit(projectile)

var speed = 800 # overwritten by weapons
var damage  # overwritten by weapons
var friendly =  false


onready var camera = get_tree().current_scene.get_node("Character/Camera2D")

func _ready():
	if not friendly:
		set_collision_layer_bit(6, false)
		set_collision_layer_bit(8, true)
		set_collision_mask_bit(4, false)
		set_collision_mask_bit(2, true)
		set_collision_mask_bit(3, true)

func _physics_process(delta):
	position += transform.x * speed * delta
	if position.x < camera.limit_left or position.x > camera.limit_right or \
			position.y < camera.limit_top or position.y > camera.limit_bottom:
		queue_free()


func hit_something(body):
	
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
