extends KinematicBody2D


var speed = 180
var friction = 0.2
var acceleration = 0.1
var vertical_Variation = 300 # How much the car can move vertically
onready var horizontal_variation = Global.train.get_node("Carriage1/CollisionShape2D").shape.extents.x * 2

enum CarStates {
	MOVING,
	STOPPING,
}
var current_state = CarStates.MOVING
var target = null # Target train connector

var velocity = Vector2.ZERO


func _ready():
	randomize()


func get_movement():
	var movement = Vector2()
	target = Global.train.carriages[0]
	if target.alive:
		var padding = 25 # So the car trailer lines up with the train connector
		if position.x < target.get_global_transform().origin.x + \
				target.get_node("Sprite").texture.get_size().x / 2 + padding:
			movement.x += 1
			current_state = CarStates.MOVING
		else:
			current_state = CarStates.STOPPING

	return movement
	

func _physics_process(delta):
	var direction = get_movement()
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)
