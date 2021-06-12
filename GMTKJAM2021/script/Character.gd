extends KinematicBody2D

onready var projectile = load("res://scene/entities/Projectile.tscn")

var speed = 180
var friction = 0.2
var acceleration = 0.1

var current_weapon = Gun

var velocity = Vector2.ZERO


func _ready():
	pass


func get_movement_input():
	var input = Vector2()
	if Input.is_action_pressed('Up'):
		input.y -= 1
	if Input.is_action_pressed('Down'):
		input.y += 1
	if Input.is_action_pressed("Left"):
		input.x -= 1
	if Input.is_action_pressed('Right'):
		input.x += 1
	return input

func _input(event):
	if Input.is_action_just_pressed("Left_Click"):
		if $ReloadTimer.is_stopped():
			shoot()

func shoot():
	var projectile_instance = projectile.instance()
	get_tree().current_scene.add_child(projectile_instance)
	projectile_instance.damage = current_weapon.damage
	projectile_instance.transform = $Gun.global_transform
	$ReloadTimer.start()

func _physics_process(delta):
	look_at(get_global_mouse_position())
	var direction = get_movement_input()
	if direction.length() > 0:
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)

