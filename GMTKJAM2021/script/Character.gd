extends KinematicBody2D


onready var current_weapon = load("res://scene/entities/Gun.tscn").instance()

var speed = 180
var friction = 0.2
var acceleration = 0.1

var item_damage_increase = 0

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
		
		# So we can hold shift and shoot 'enemy' bullets for debug
		if OS.is_debug_build() and Input.is_action_pressed("Shift"):
			shoot(true)
			
		elif $ReloadTimer.is_stopped():
			shoot()

func shoot(debug_friendly_fire=false):
	var projectile_instance = load(current_weapon.projectile).instance()
	get_tree().current_scene.add_child(projectile_instance)
	projectile_instance.damage = current_weapon.damage + item_damage_increase
	projectile_instance.transform = $Gun/Position2D.global_transform
	if not debug_friendly_fire:
		projectile_instance.friendly = true
	$ReloadTimer.set_wait_time(current_weapon.reload_time)
	$ReloadTimer.start()

func _physics_process(delta):
	look_at(get_global_mouse_position())
	var direction = get_movement_input()
	if direction.length() > 0:
		$AnimatedSprite.play("walking")
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
		$AnimatedSprite.stop()
	velocity = move_and_slide(velocity)

