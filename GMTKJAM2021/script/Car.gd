extends KinematicBody2D

# NOTE: Car technically targets carriages + an offset, not the connectors

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
var target = null # Target train connector

var enemies = []
var all_enemies_dead = false
var bail = false
var bail_angle = 0
var bail_angle_acceleration = 0.05

var drift_direction = Vector2.ZERO
var velocity = Vector2.ZERO

onready var car_spawn = get_tree().current_scene.get_node("CarSpawn")
onready var train = get_tree().current_scene.get_node("Train")


func _ready():
# warning-ignore:return_value_discarded
	GlobalEvents.connect("enemy_dead", self, "_on_enemy_dead")
# warning-ignore:return_value_discarded
	$EnemySpawner.connect("add_enemy", self, "_on_enemy_added")
	$EnemySpawner.seed_spawner()

func get_movement():
	var movement = Vector2()
	target = train.carriages[1 + train.carriage_buffer]
	if target.alive:
		var padding = -25 # So the trailer lines up with the connector (changes depending on speed)
#		if position.x < target.get_global_transform().origin.x + \
#				target.get_node("Sprite").texture.get_size().x / 2 + padding:
		if position.x < target.get_node("Connector").global_position.x + padding:
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
	if target != null:
		for i in enemies:
			i.look_at(target.get_node("Connector").global_position)
			
	var direction = get_movement()
	if direction.length() > 0:
		if not all_enemies_dead:
			if current_state == CarStates.STOPPING:
				velocity = lerp(velocity, direction.normalized() * drift_speed, drift_acceleration)
			elif current_state == CarStates.MOVING:
				velocity = lerp(velocity, direction.normalized() * speed, acceleration)
		elif $BailTimer.is_stopped():
			bail_angle = lerp(bail_angle, 1, bail_angle_acceleration)
			velocity = lerp(velocity, Vector2(0.3,-bail_angle) * speed*1.5, acceleration)
			if position.x > get_tree().current_scene.get_node("Character/Camera2D").limit_right + \
					$Sprite.texture.get_size().x/2 or position.y < 0 - $Sprite.texture.get_size().y/2 - 30:
				queue_free()
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)


func _on_DriftTimer_timeout():
	var rand = randi() % 4
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
					target.get_node("Sprite").texture.get_size().x / 2 + drift_bound.x:
				drift_direction = Vector2(1,0)
			else:
				drift_direction = Vector2(-1,0)
		3:
			if position.x < target.get_global_transform().origin.x - \
					target.get_node("Sprite").texture.get_size().x / 2 - drift_bound.x:
				drift_direction = Vector2(-1,0)
			else:
				drift_direction = Vector2(1,0)

func _on_enemy_added(enemy):
	add_child(enemy)
	enemies.append(enemy)


func _on_enemy_dead(enemy):
	enemies.erase(enemy)
	if enemies.size() == 0:
		all_enemies_dead = true
		$BailTimer.start()


func _on_BailTimer_timeout():
	bail = true
