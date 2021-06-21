extends KinematicBody2D

class_name Character

onready var current_weapon = $Pistol

signal blink(carriage_num)

var speed = 180
var friction = 0.2
var acceleration = 0.1

var MAX_HP = 10
var scaled_hp = 100
var item_damage_increase = 0

var clip_size

var stunned = false
var velocity = Vector2.ZERO

onready var train = get_tree().current_scene.get_node("Train")
var current_carriage = 1 setget set_current_carriage_ref
onready var current_carriage_ref = train.carriages[1]

func _ready():
	current_weapon.picked_up = true
	$Ammo/ReloadTimer.wait_time = current_weapon.reload_time
	clip_size = current_weapon.clip_size

func _process(_delta):
	$HP.global_rotation = 0
	$Ammo.global_rotation = 0
	if Input.is_action_pressed("Left_Click"): # in process so one can hold down button to fire
		# So we can hold shift and shoot 'enemy' bullets for debug
		if OS.is_debug_build():
			if Input.is_action_pressed("Shift") and $FiringTimer.is_stopped() and not stunned:
				shoot(true)
			elif $FiringTimer.is_stopped() and not stunned:
				shoot()
		elif $FiringTimer.is_stopped() and not stunned:
			shoot()
	
	if not $Ammo/ReloadTimer.is_stopped():
		# Reloading
		var scaled_reload = (float($Ammo/ReloadTimer.time_left) / float(current_weapon.reload_time) * 100.0)
		$Ammo/AmmoBar.value = 100-scaled_reload

func shoot(debug_shoot_as_enemy=false):
	if $Ammo/ReloadTimer.is_stopped():
		if clip_size >= 1:
			clip_size -= 1
			var scaled_ammo = float(clip_size) / float(current_weapon.clip_size) * 100
			$Ammo/AmmoBar.value = scaled_ammo
			if clip_size <= 0:
				$Ammo/ReloadTimer.start()
			var projectile_instance = load(current_weapon.projectile).instance()
			projectile_instance.damage = current_weapon.damage + item_damage_increase
			projectile_instance.transform = get_node(current_weapon.name + "/Position2D").global_transform
			projectile_instance.speed = current_weapon.projectile_speed
			if not debug_shoot_as_enemy:
				projectile_instance.friendly = true
			else:
				projectile_instance.friendly = false
			get_tree().current_scene.add_child(projectile_instance)
			$FiringTimer.set_wait_time(current_weapon.firing_rate)
			$FiringTimer.start()
			Global.audio.playGunshot(current_weapon.name)


func get_movement_input():
	var input = Vector2.ZERO
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
	if Input.is_action_just_pressed("ui_accept"):
		print(str(current_carriage) + ": " + str(current_carriage_ref))
		#print(str(train.carriages))
		
	if Input.is_action_just_pressed("Right_Click"):
		blink()

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	var direction = get_movement_input()

	if direction.length() > 0:
		$AnimatedSprite.play("walking")
		velocity = lerp(velocity, direction.normalized() * speed + current_carriage_ref.velocity, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO + current_carriage_ref.velocity, friction)
		$AnimatedSprite.stop()

	
	var margin = Vector2(30,30)
	var sprite_size = current_carriage_ref.get_node("Sprite").texture.get_size()
	position.x = clamp(position.x, current_carriage_ref.global_position.x - sprite_size.x / 2 + margin.x, \
			current_carriage_ref.global_position.x + sprite_size.x / 2 - margin.x)
	position.y = clamp(position.y, current_carriage_ref.global_position.y - sprite_size.y / 2 + margin.y, \
			current_carriage_ref.global_position.y + sprite_size.y / 2 - margin.y)
			
	velocity = move_and_slide(velocity)
	
	if position.x < -10:
		GlobalEvents.emit_signal("game_over")


func blink():
	if rotation_degrees < -90 or rotation_degrees > 90:
		#Facing left
		emit_signal("blink", current_carriage-1)
	else:
		#Facing right
		emit_signal("blink", current_carriage+1)
	
func successful_blink(new_pos, new_carriage):
	position = new_pos
	self.current_carriage = new_carriage

func _on_Item_picked_up(item):
	get_tree().current_scene.spawned_items.erase(item) # Erase item from global item list
	print('picked up: ' + str(item.display_name))
	match item.type:
		item.ItemType.POWER_UP:
			pass
		item.ItemType.HEALTH:
			$HP.visible = true
			if scaled_hp < 100:
				var scaled_health_increase = (float(item.value) / float(MAX_HP) * 100.0)
				scaled_hp += scaled_health_increase
				$HP/HPBar.value = scaled_hp
			else:
				scaled_hp = 100
				$HP/HPBarTimer.stop()
				$HP/HPBarTimer.start()
		item.ItemType.GUN:
			call_deferred("remove_child",get_node(current_weapon.name))
			current_weapon = load(item.filename).instance()
			current_weapon.picked_up = true
			current_weapon.position = $GunPosition.position
			clip_size = current_weapon.clip_size
			$Ammo/ReloadTimer.wait_time = current_weapon.reload_time
			call_deferred("add_child", current_weapon)
			$FiringTimer.stop()
			
func damage(dmg):
	if not stunned:
		var scaled_damage = (float(dmg) / float(MAX_HP) * 100.0)
		scaled_hp -= scaled_damage
		$HP.visible = true
		$HP/HPBar.value = scaled_hp
		if scaled_hp <= 0:
			stun()

func stun():
	stunned = true
	modulate = Color(1.0, 1.0, 1.0, 0.6)
	$StunTimer.start()
	
func _on_Projectile_hit(projectile):
	damage(projectile.damage)


func _on_StunTimer_timeout():
	stunned = false
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	scaled_hp = 100
	$HP/HPBar.value = scaled_hp


func _on_HPBarTimer_timeout():
	$HP.visible = false

func set_current_carriage_ref(value):
	current_carriage = value
	current_carriage_ref = train.carriages[value]


func _on_ReloadTimer_timeout():
	clip_size = current_weapon.clip_size
	$Ammo/AmmoBar.value = 100

