extends Node2D


var car = "res://scene/entities/Car.tscn"
var car_spawn_time = 10 # can be randomized

func _ready():
	randomize()
	Global.train = $Train # train reference so we know what carriages are alive
	
	# So cars dont stack up
	if OS.is_debug_build():
		$CarSpawnTimer.one_shot = true


func _unhandled_input(event):
	if OS.is_debug_build():
		if Input.is_action_just_pressed("ui_select"):
			var car = get_node("Car")
			print(str(car.target) + "     " + str(car.target.get_index()))


func _on_CarSpawnTimer_timeout():
	var car_instance = load(car).instance()
	car_instance.position = $CarSpawn.position
	add_child(car_instance)
	
	# CarSpawnTimer set to 1sec so car spawns instantly
	$CarSpawnTimer.wait_time = car_spawn_time
