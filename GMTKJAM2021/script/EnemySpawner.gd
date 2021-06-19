extends Node

signal add_enemy(enemy)

var enemy = preload("res://scene/entities/Enemy.tscn")

# The following three variables should add up to 100
var one_enemy_chance = 50
var two_enemy_chance = 40
var three_enemy_chance = 10

var rand

func _ready():
	pass

func seed_spawner():
	randomize()
	rand = randi() % 100 + 1
	if rand <= one_enemy_chance:
		spawn_enemies(1)
	elif rand <= one_enemy_chance + two_enemy_chance:
		spawn_enemies(2)
	elif rand <= one_enemy_chance + two_enemy_chance + three_enemy_chance:
		spawn_enemies(3)

func spawn_enemies(number):
	print("rand: " + str(rand) + "   number: " + str(number))
	for i in range(0, number):
		var enemy_instance = enemy.instance()
		enemy_instance.position = get_child(i).position
		emit_signal("add_enemy", enemy_instance)

