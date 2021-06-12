extends KinematicBody2D

# Train reference so the car can know where the carriage connectors are
onready var train_reference = load("res://scene/entities/Train.tscn").instance()
var speed = 180
var friction = 0.2
var acceleration = 0.1
var vertical_Variation = 300 # How much the car can move vertically
onready var horizontal_variation = train_reference.get_node("Carriage1/Area2D/CollisionShape2D").shape.extents.x * 2

var velocity = Vector2.ZERO


func _ready():
	print(horizontal_variation)
	randomize()

func get_movement():
	var movement = Vector2()

	return movement
	

func _physics_process(delta):
	var direction = get_movement()
	if direction.length() > 0:
		$AnimatedSprite.play("walking")
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
		$AnimatedSprite.stop()
	velocity = move_and_slide(velocity)
