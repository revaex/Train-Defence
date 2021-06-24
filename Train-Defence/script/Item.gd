extends Area2D

class_name Item

enum ItemType {
	POWER_UP,
	HEALTH,
	GUN,
}

var type # = POWER_UP, HEALTH, GUN
var value # = -0.3(sec), 10 (hp)
var display_name # "Fast Reload", "Health Potion", "AK-47"

var picked_up = false
var on_carriage # carriage number (int), use train.carriages[on_carriage] for reference

onready var train = get_tree().current_scene.get_node("Train")
onready var saved_position = Vector2(position.x, position.y)
var velocity = Vector2.ZERO


func _physics_process(delta):
	if not picked_up:
		if not train.carriages[on_carriage] is String:
			if not train.carriages[on_carriage].alive:
				velocity = train.carriages[on_carriage].velocity
				translate(velocity * delta)


func _on_Item_body_entered(body):
	if body is Character and not picked_up:
		GlobalEvents.emit_signal("item_picked_up", self)
		queue_free()

