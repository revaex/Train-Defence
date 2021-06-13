extends KinematicBody2D

var speed = 90
var acceleration = 0.1
var velocity = Vector2.ZERO

var scaled_hp = 100.0

onready var index = get_parent().name.rsplit("Carriage", false)[0] as int

signal connector_has_broken(connector_num)

export var hp : int
var alive = true

func _ready():
# warning-ignore:return_value_discarded
	connect("connector_has_broken", get_parent().get_parent(), "lose_carriages")
	return
	
func _physics_process(_delta):
#	if !alive:
#		var direction = Vector2(-1,0)
#		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
#		velocity = move_and_slide(velocity)
	return


func damage(dmg : int):
	var scaled_damage = (float(dmg) / float(hp) * 100.0)
	scaled_hp -= scaled_damage
	$HPBar.visible = true
	$HPBar.value = scaled_hp
	if scaled_hp <= 0:
		break_connector()
	return
	
func break_connector():
	print("Connector Broke!")
	#var order = name.rsplit("Connector", false)[0] as int
	emit_signal("connector_has_broken", index )
	queue_free()
	return

func die():
	alive = false
	return


func _on_Projectile_hit(projectile):
	damage(projectile.damage)
