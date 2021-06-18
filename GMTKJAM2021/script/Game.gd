extends Node2D


var car = "res://scene/vehicles/Car.tscn"
var car_spawn_time = 15 # can be randomized

var base_item = Item.new()
onready var train = get_tree().current_scene.get_node("Train")
var spawned_items = []

func _ready():
	Global.audio.playTrainMovement()
	
	$ItemSpawner.spawn(4, base_item.ItemType.HEALTH, 5)
	
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

