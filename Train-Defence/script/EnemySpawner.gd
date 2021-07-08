extends Node

signal add_enemy(enemy)

var enemy = preload("res://scene/entities/Enemy.tscn")

# The following vector values should add up to 100
var enemy_spawn_chance = [60, 35, 5]

var spawn_variation = 30 # variation in y axis

var enemy_spawn_in_use = [false, false, false]


func _ready():
	assert(enemy_spawn_chance[0] + enemy_spawn_chance[1] + enemy_spawn_chance[2] == 100)

func seed_spawner(number):
	if number:
		_init_spawner(min(number, 3))
		return
		
	randomize()
	var rand = randi() % 100 + 1
	if rand <= enemy_spawn_chance[0]:
		_init_spawner(1)
	elif rand <= enemy_spawn_chance[0] + enemy_spawn_chance[1]:
		_init_spawner(2)
	elif rand <= enemy_spawn_chance[0] + enemy_spawn_chance[1] + enemy_spawn_chance[2]:
		_init_spawner(3)

func _init_spawner(number):
	var rand_spawn = randi() % 3
	for _i in range(0, number):
		if not enemy_spawn_in_use[rand_spawn]:
			_spawn_enemy(rand_spawn)
		else:
			rand_spawn = (rand_spawn + 1) % 3
			_spawn_enemy(rand_spawn)

func _spawn_enemy(rand_spawn):
	enemy_spawn_in_use[rand_spawn] = true
	var rand_spawn_variation = randi() % spawn_variation
	var enemy_instance = enemy.instance()
	enemy_instance.position = get_child(rand_spawn).position
	enemy_instance.position.y -= rand_spawn_variation
	if rand_spawn == 0:
		enemy_instance.target_character = true
	emit_signal("add_enemy", enemy_instance)
