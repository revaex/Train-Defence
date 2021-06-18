extends Node2D

class_name ItemSpawner


onready var base_item = Item.new()
onready var train = get_tree().current_scene.get_node("Train")

var items = {}


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
			_carriage = randi() % train.get_child_count() + 1
		var item_instance = load(items[type][rand]).instance()
		item_instance.on_carriage = _carriage
		var target = train.carriages[_carriage]
		var target_size = target.get_node("Sprite").texture.get_size()
		var margin = Vector2(40,40) # So items don't spawn on the edge of a carriage
		var rand_x = target.get_global_transform().origin.x - target_size.x / 2  + \
				randi() % int(target_size.x - margin.x) + margin.x/2
		var rand_y = target.get_global_transform().origin.y - target_size.y / 2  + \
				randi() % int(target_size.y - margin.y) + margin.y/2
		item_instance.position = Vector2(rand_x, rand_y)
		get_tree().current_scene.spawned_items.append(item_instance)
		get_tree().current_scene.add_child(item_instance)

