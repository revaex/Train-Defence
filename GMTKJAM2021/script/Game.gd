extends Node2D


var car = "res://scene/vehicles/Car.tscn"
var car_spawn_time = 15 # can be randomized

var base_item = Item.new()
onready var train = get_tree().current_scene.get_node("Train")
var spawned_items = []

func _ready():
	Global.audio.playTrainMovement()
	
	# Spawning in test item
	var Spawner = ItemSpawner.new(train)
	Spawner.seed_type(base_item.ItemType.GUN)
	for i in range(1,13):
		var test_item = Spawner.spawn(i)
		spawned_items.append(test_item)
		add_child(test_item)
	
	# So cars dont stack up
	if OS.is_debug_build():
		$CarSpawnTimer.one_shot = true


func _on_CarSpawnTimer_timeout():
	var car_instance = load(car).instance()
	car_instance.position = $CarSpawn.position
	add_child(car_instance)
	
	# CarSpawnTimer set to 1sec so car spawns instantly
	$CarSpawnTimer.wait_time = car_spawn_time

func tele_to_carriage(carriage_num):
	for i in train.get_children():
		if i.is_in_group("carriages"):
			if carriage_num == i.name.rsplit("Carriage", false)[0] as int:
				$Character.successful_blink(i.global_position, carriage_num)


class ItemSpawner:
	var base_item = Item.new()
	var rand
	var type
	var train
	var items = {
		base_item.ItemType.HEALTH: [
			"res://scene/items/HealthPotion.tscn"
		],
		base_item.ItemType.GUN: [
			"res://scene/items/Pistol.tscn",
			"res://scene/items/MachineGun.tscn",
			"res://scene/items/RocketLauncher.tscn"
		],
		base_item.ItemType.POWER_UP: 0,
	}
	
	func _init(_train):
		train = _train
		
	func seed_type(_type):
		type = _type
		randomize()
		match type:
			base_item.ItemType.HEALTH:
				rand = randi() % items[type].size()
			base_item.ItemType.GUN:
				rand = randi() % items[type].size()
			base_item.ItemType.POWER_UP:
				rand = randi() % items[type].size()
	
	func spawn(carriage, _type=base_item.ItemType.GUN):
		seed_type(_type)
		randomize()
		assert(train != null)
		if carriage == null:
			carriage = randi() % 11 + 1
		var item_instance = load(items[type][rand]).instance()
		item_instance.on_carriage = carriage
		
		var target = train.carriages[carriage]
		var target_size = target.get_node("Sprite").texture.get_size()
		var margin = Vector2(40,40)
		var rand_x = target.get_global_transform().origin.x - target_size.x / 2  + \
				randi() % int(target_size.x - margin.x) + margin.x/2
		var rand_y = target.get_global_transform().origin.y - target_size.y / 2  + \
				randi() % int(target_size.y - margin.y) + margin.y/2
		item_instance.position = Vector2(rand_x, rand_y)
		return item_instance
