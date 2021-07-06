extends Area2D

class_name Item

enum ItemType {
	POWER_UP,
	HEALTH,
	GUN,
}

enum ItemSubType {
	FLAT,
	MAX,
	REGEN,
}

var type # = POWER_UP, HEALTH, GUN
var sub_type # FLAT, MAX, REGEN, Used mainly for "health" category (and maybe power-up?)
var data = {
	"value" : null,
	"ticks" : null,
	"tick_time" : null,
}
var display_name # "Fast Reload", "Health Potion", "AK-47"

var picked_up = false
var on_carriage # carriage number (int), use train.carriages[on_carriage] for reference

onready var train = get_tree().current_scene.get_node("Train")
onready var saved_position = Vector2(position.x, position.y)
var velocity = Vector2.ZERO


func _ready():
	if on_carriage == null and not picked_up and not owner is Entity:
		# So items that are dragged onto the game scene directly
		# (not spawned via the ItemSpawner) can be detected by the UI MapPanel
		GlobalEvents.emit_signal("item_spawned", self)

func _on_Item_body_entered(body):
	if body is Character and not picked_up:
		GlobalEvents.emit_signal("item_picked_up", self)
		queue_free()

