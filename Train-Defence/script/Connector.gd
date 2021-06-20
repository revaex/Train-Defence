extends KinematicBody2D

var speed = 90
var acceleration = 0.1
var velocity = Vector2.ZERO

var scaled_hp = 100.0

onready var index = get_parent().name.rsplit("Carriage", false)[0] as int

signal connector_has_broken(connector_num)

var hp = 10
var alive = true

func _ready():
# warning-ignore:return_value_discarded
	connect("connector_has_broken", get_parent().get_parent(), "lose_carriages")



func damage(dmg):
	if alive:
		var scaled_damage = (float(dmg) / float(hp) * 100.0)
		scaled_hp -= scaled_damage
		$HPBar.visible = true
		$HPBar.value = scaled_hp
		if scaled_hp <= 0:
			alive = false
			break_connector()

func break_connector():
		print("Connector Broke!")
		emit_signal("connector_has_broken", index )
		queue_free()

func _on_Projectile_hit(projectile):
	damage(projectile.damage)
