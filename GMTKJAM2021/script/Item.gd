extends Node

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


func _ready():
	connect("item_picked_up", get_tree().current_scene.get_node("Character"), "_on_Item_picked_up")
