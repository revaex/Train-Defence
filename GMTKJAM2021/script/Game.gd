extends Node2D


var car = "res://scene/entities/Car.tscn"
var car_spawn_time = 15 # can be randomized

var base_item = Item.new()

class ItemSpawner:
	var base_item = Item.new()
	var rand
	var type
	var items = {
		base_item.ItemType.HEALTH: [
			"res://scene/entities/ItemHP.tscn"
		],
		base_item.ItemType.GUN: [
			"res://scene/entities/Pistol.tscn",
			"res://scene/entities/MachineGun.tscn",
			"res://scene/entities/RocketLauncher.tscn"
		],
		base_item.ItemType.POWER_UP: 0,
	}
	
	func _init(_type):
		type = _type
		randomize()
		match type:
			base_item.ItemType.HEALTH:
				rand = randi() % items[type].size()
				print("rand: " + str(rand))
			base_item.ItemType.GUN:
				rand = randi() % items[type].size()
				print("rand: " + str(rand))
			base_item.ItemType.POWER_UP:
				rand = randi() % items[type].size()
				print("rand: " + str(rand))
	func spawn():
		var item_instance = load(items[type][rand]).instance()
		item_instance.position = Vector2(100,100)
		return item_instance

func _ready():
	Global.audio.playTrainMovement()
	# Spawning in test item
	var Spawner = ItemSpawner.new(base_item.ItemType.GUN)
	var test_item = Spawner.spawn()
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
	var train = get_node("Train")
	for i in train.get_children():
		if i.is_in_group("carriages"):
			if carriage_num == i.name.rsplit("Carriage", false)[0] as int:
				$Character.successful_blink(i.global_position, carriage_num)
	return
