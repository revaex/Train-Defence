extends KinematicBody2D

var speed = 90
var acceleration = 0.1
var velocity = Vector2.ZERO

var scaled_hp = 100.0

onready var index = get_parent().name.rsplit("Carriage", false)[0] as int

var hp = 10
var alive = true

func _ready():
	pass


func take_damage(dmg, _shooter, _incoming_direction):
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
		GlobalEvents.emit_signal("train_connector_broken", index)
		queue_free()

