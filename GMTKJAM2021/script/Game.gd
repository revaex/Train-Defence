extends Node2D


var car = "res://scene/entities/Car.tscn"
var car_spawn_time = 10 # can be randomized

func _ready():
	Global.train = $Train # train reference so we know what carriages are alive
	Global.audio.playTrainMovement()
	# Spawning in test item
	var item = load("res://scene/entities/ItemHP.tscn").instance()
	add_child(item)
	item.position = Vector2(150,100)
	
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
