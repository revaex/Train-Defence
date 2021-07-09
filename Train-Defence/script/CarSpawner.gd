extends Node

class_name CarSpawner

# Each time a car is spawned, there is a random chance that CarSpawnTimer
# will restart and spawn an extra car
var rand_spawn_chance = 10
var spawn_count = 1 # How many cars spawn at a time. Can be increased for extra difficulty

export (float) var car_spawn_timer = 5
export (bool) var spawn_cars = true

onready var car_scene = preload("res://scene/vehicles/Car.tscn")
var cars = []

func _ready():
	assert(rand_spawn_chance <= 100)
	
# warning-ignore:return_value_discarded
	GlobalEvents.connect("car_despawned", self, "_on_car_despawned")


func spawn(number, top=true):
	if spawn_cars:
		var spawn_gap = 0
		for i in range(0,number):
			var car_instance = car_scene.instance()
			if i >= 1:
				spawn_gap += car_instance.get_node("CollisionShape2D").shape.extents.x * 2
			if top:
				car_instance.position = $CarSpawnTop.position
			else:
				car_instance.position = $CarSpawnBottom.position
				car_instance.spawned_at_top = false
			car_instance.position.x -= spawn_gap
			get_tree().current_scene.add_child(car_instance)
			cars.append(car_instance)
			GlobalEvents.emit_signal("car_spawned", car_instance)
			var rand = randi() % 100
			if rand <= rand_spawn_chance:
				$CarSpawnTimer.start()

func _on_CarSpawnTimer_timeout():
	# This is only necessary for debug purposes so the car spawns instantly
	$CarSpawnTimer.wait_time = car_spawn_timer
	
	spawn(spawn_count)

func _on_car_despawned(car):
	cars.erase(car)
	car.queue_free()
	$CarSpawnTimer.start()

