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

var drift_direction = Vector2.ZERO
var velocity = Vector2.ZERO
onready var car_spawn = get_tree().current_scene.get_node("CarSpawn")
onready var train = get_tree().current_scene.get_node("Train")


func get_movement():
	var movement = Vector2()
	target = train.carriages[1 + train.carriage_buffer]
	if target.alive:
		var padding = -20 # So the trailer lines up with the connector (changes depending on speed)
		if position.x < target.get_global_transform().origin.x + \
				target.get_node("Sprite").texture.get_size().x / 2 + padding:
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
		if current_state == CarStates.STOPPING:
			velocity = lerp(velocity, direction.normalized() * drift_speed, drift_acceleration)
		elif current_state == CarStates.MOVING:
			velocity = lerp(velocity, direction.normalized() * speed, acceleration)
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

