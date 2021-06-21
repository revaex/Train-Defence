extends KinematicBody2D


var speed = 180
var friction = 0.05
var acceleration = 0.05

var drift_speed = 10
var drift_acceleration = 0.04
var drift_bound = Vector2(20, 5)

enum CarStates {
	MOVING,
	STOPPING, # should really be 'drifting'...
}
var current_state = CarStates.MOVING

var enemies = []
var all_enemies_dead = false
var bail = false
var bail_angle = Vector2(0.9, 0)
var bail_angle_acceleration = 0.04

var drift_direction = Vector2.ZERO
var velocity = Vector2.ZERO

var spawned_at_top = true

onready var car_spawn_top = get_tree().current_scene.get_node("CarSpawner/CarSpawnTop")
onready var car_spawn_bottom = get_tree().current_scene.get_node("CarSpawner/CarSpawnBottom")
onready var train = get_tree().current_scene.get_node("Train")
onready var target = train.leftmost_carriage.connector

func _ready():
# warning-ignore:return_value_discarded
	GlobalEvents.connect("train_connector_broken", self, "_on_train_connector_broken")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("enemy_dead", self, "_on_enemy_dead")
# warning-ignore:return_value_discarded
	$EnemySpawner.connect("add_enemy", self, "_on_enemy_added")
	$EnemySpawner.seed_spawner()

func get_movement():
	var movement = Vector2()
	if target != null and is_instance_valid(target):
		if target.alive:
			var padding = -25 # So the trailer lines up with the connector (changes depending on speed)
			if position.x < target.global_position.x + padding:
				movement.x += 1
				current_state = CarStates.MOVING
			else:
				current_state = CarStates.STOPPING
	if current_state == CarStates.STOPPING:
		if $DriftTimer.is_stopped():
			$DriftTimer.start()
		movement = drift_direction
	return movement


func _physics_process(_delta):
	var direction = get_movement()
	if direction.length() > 0:
		if not all_enemies_dead:
			if current_state == CarStates.STOPPING:
				velocity = lerp(velocity, direction.normalized() * drift_speed, drift_acceleration)
			elif current_state == CarStates.MOVING:
				velocity = lerp(velocity, direction.normalized() * speed, acceleration)
		elif $BailTimer.is_stopped():
			bail_angle.y = lerp(bail_angle.y, -1, bail_angle_acceleration)
			velocity = lerp(velocity, Vector2(bail_angle.x, bail_angle.y) * speed*1.5, acceleration)
			if position.x > get_tree().current_scene.get_node("Character/Camera2D").limit_right + \
					$Sprite.texture.get_size().x/2 or position.y < 0 - $Sprite.texture.get_size().y/2 - 30:
				GlobalEvents.emit_signal("car_despawned", self)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
		
	if (1 + train.carriage_buffer) >= train.carriages.size():
		GlobalEvents.emit_signal("game_over")
		
	velocity = move_and_slide(velocity)


func _on_DriftTimer_timeout():
	var rand = randi() % 4
	var car_spawn
	if spawned_at_top:
		car_spawn = car_spawn_top
	else:
		car_spawn = car_spawn_bottom
	match rand:
		0:
			if position.y < car_spawn.position.y + drift_bound.y:
				drift_direction = Vector2(0,1)
			else:
				drift_direction = Vector2(0,-1)
		1:
			if position.y > car_spawn.position.y - drift_bound.y:
				drift_direction = Vector2(0,-1)
			else:
				drift_direction = Vector2(0, 1)
		2:
			if position.x < target.get_global_transform().origin.x + \
					 + drift_bound.x:
				drift_direction = Vector2(1,0)
			else:
				drift_direction = Vector2(-1,0)
		3:
			if position.x < target.get_global_transform().origin.x - \
					 - drift_bound.x:
				drift_direction = Vector2(-1,0)
			else:
				drift_direction = Vector2(1,0)


func _on_enemy_added(enemy):
	add_child(enemy)
	enemies.append(enemy)
	enemy.car = self


func _on_enemy_dead(enemy):
	enemies.erase(enemy)
	if enemies.size() == 0:
		all_enemies_dead = true
		$BailTimer.start()


func _on_BailTimer_timeout():
	bail = true


func _on_train_connector_broken(_index):
	target = train.leftmost_carriage.connector
