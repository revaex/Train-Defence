extends Node

class_name CarSpawner

# Each time a car is spawned, there is a random chance that CarSpawnTimer
# will restart and spawn an extra car
var rand_spawn_chance = 10

var car = "res://scene/vehicles/Car.tscn"

func _ready():
	assert(rand_spawn_chance <= 100)

func spawn(number):
	var spawn_gap = 0
	for i in range(0,number):
		var car_instance = load(car).instance()
		if i >= 1:
			spawn_gap += car_instance.get_node("Sprite").texture.get_size().x
		car_instance.position = get_tree().current_scene.get_node("CarSpawn").position
		car_instance.position.x -= spawn_gap
		get_tree().current_scene.add_child(car_instance)
		var rand = randi() % 100
		if rand <= rand_spawn_chance:
			get_tree().current_scene.get_node("CarSpawnTimer").start()

