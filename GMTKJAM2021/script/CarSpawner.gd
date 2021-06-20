extends Node

class_name CarSpawner

# Each time a car is spawned, there is a random chance that CarSpawnTimer
# will restart and spawn an extra car
var rand_spawn_chance = 10

var car = "res://scene/vehicles/Car.tscn"

func _ready():
	assert(rand_spawn_chance <= 100)

func spawn(number):
	for _i in range(0,number):
		var car_instance = load(car).instance()
		car_instance.position = get_tree().current_scene.get_node("CarSpawn").position
		get_tree().current_scene.add_child(car_instance)
		var rand = randi() % 100
		print("spawn rand: " + str(rand))
		if rand <= rand_spawn_chance:
			get_tree().current_scene.get_node("CarSpawnTimer").start()

