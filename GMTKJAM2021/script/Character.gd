extends KinematicBody2D


onready var current_weapon = load("res://scene/entities/Pistol.tscn").instance()

var speed = 180
var friction = 0.2
var acceleration = 0.1

var MAX_HP = 5
var scaled_hp = 100
var item_damage_increase = 0

var stunned = false
var velocity = Vector2.ZERO


func _ready():
	pass


func _process(_delta):
	$HPBarNode.global_rotation = 0


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

func _input(_event):
	if Input.is_action_just_pressed("Left_Click"):
		
		# So we can hold shift and shoot 'enemy' bullets for debug
		if OS.is_debug_build() and Input.is_action_pressed("Shift"):
			shoot(true)
			
		elif $ReloadTimer.is_stopped() and not stunned:
			shoot()

func shoot(debug_friendly_fire=false):
	var projectile_instance = load(current_weapon.projectile).instance()
	get_tree().current_scene.add_child(projectile_instance)
	projectile_instance.damage = current_weapon.damage + item_damage_increase
	projectile_instance.transform = get_node(current_weapon.name + "/Position2D").global_transform
	if not debug_friendly_fire:
		projectile_instance.friendly = true
	$ReloadTimer.set_wait_time(current_weapon.reload_time)
	$ReloadTimer.start()

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	var direction = get_movement_input()
	if direction.length() > 0:
		$AnimatedSprite.play("walking")
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction)
		$AnimatedSprite.stop()
	velocity = move_and_slide(velocity)

func _on_Item_picked_up(item):
	print('picked up: ' + str(item.display_name))
	match item.type:
		item.ItemType.POWER_UP:
			pass
		item.ItemType.HEALTH:
			$HPBarNode.visible = true
			if scaled_hp < 100:
				var scaled_health_increase = (float(item.value) / float(MAX_HP) * 100.0)
				scaled_hp += scaled_health_increase
				$HPBarNode/HPBar.value = scaled_hp
			else:
				scaled_hp = 100
				$HPBarTimer.stop()
				$HPBarTimer.start()
		item.ItemType.GUN:
			call_deferred("remove_child",get_node(current_weapon.name))
			current_weapon = load("res://scene/entities/" + item.name + ".tscn").instance()
			current_weapon.picked_up = true
			current_weapon.position = $GunPosition.position
			call_deferred("add_child", current_weapon)
func damage(dmg : int):
	var scaled_damage = (float(dmg) / float(MAX_HP) * 100.0)
	scaled_hp -= scaled_damage
	$HPBarNode.visible = true
	$HPBarNode/HPBar.value = scaled_hp
	if scaled_hp <= 0:
		stun()

func stun():
	stunned = true
	modulate = Color(1.0, 1.0, 1.0, 0.6)
	$StunTimer.start()
	
func _on_Projectile_hit(projectile):
	damage(projectile.damage)
	projectile.queue_free()


func _on_StunTimer_timeout():
	stunned = false
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	scaled_hp = 100
	$HPBarNode/HPBar.value = scaled_hp


func _on_HPBarTimer_timeout():
	$HPBarNode.visible = false
