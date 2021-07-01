extends Node

class_name ItemSpawner


onready var base_item = Item.new()
onready var train = get_tree().current_scene.get_node("Train")

var items = {}
var spawned_items = []


func _ready():
	randomize()
	var health_items = Global.files_from_dir("res://scene/items/health/")
	var gun_items = Global.files_from_dir("res://scene/items/guns/")
	var power_up_items = Global.files_from_dir("res://scene/items/power_ups/")
	
	items = {
		base_item.ItemType.HEALTH : health_items,
		base_item.ItemType.GUN : gun_items,
		base_item.ItemType.POWER_UP : power_up_items
	}

func _seed_type(type):
	var rand
	match type:
		base_item.ItemType.HEALTH:
			rand = randi() % items[type].size()
		base_item.ItemType.GUN:
			rand = randi() % items[type].size()
		base_item.ItemType.POWER_UP:
			rand = randi() % items[type].size()
	return rand

func spawn(total_spawns, type=base_item.ItemType.GUN, carriage=null):
	var _carriage = carriage
	for i in total_spawns:
		var rand = _seed_type(type)
		if carriage == null:
			_carriage = randi() % train.total_carriages + 1
		var item_instance = load(items[type][rand]).instance()
		item_instance.on_carriage = _carriage
		var target = train.carriages[_carriage]
		var target_size = target.get_node("CollisionShape2D").shape.extents
		var margin = Vector2(50,55) # So items don't spawn on the edge of a carriage
		var rand_x = randi() % int(target_size.y*2 - margin.x/2) - margin.x*2
		var rand_y = randi() % int(target_size.x*2 - margin.y/2) - margin.y
		item_instance.position = Vector2(rand_x, rand_y)
		spawned_items.append(item_instance)
		get_tree().current_scene.get_node("Train").carriages[item_instance.on_carriage].add_child(item_instance)
		GlobalEvents.emit_signal("item_spawned", item_instance)

