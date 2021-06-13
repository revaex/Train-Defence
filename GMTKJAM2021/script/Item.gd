extends Node2D

class_name Item

signal item_picked_up(item)

enum ItemType {
	POWER_UP,
	HEALTH,
	GUN,
}

var type # = POWER_UP, HEALTH, GUN
var value # = -0.3(sec), 10 (hp), 2 (base dmg)
var display_name # "Fast Reload", "Health Potion", "AK-47"

var picked_up = false

func _physics_process(_delta):
	pass

func _ready():
# warning-ignore:return_value_discarded
	connect("item_picked_up", get_tree().current_scene.get_node("Character"), "_on_Item_picked_up")
	

func picked_up_by(body):
	if body.is_in_group("character"):
		emit_signal("item_picked_up", self)
		queue_free()

