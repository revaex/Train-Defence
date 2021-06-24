extends Entity

class_name Character


signal blink(carriage_num)

var stunned = false # Character becomes stunned when hp reaches 0
var stun_time = 3.0 # Flat amount of stun time. Stun time resets if shot again while in stun

onready var train = get_tree().current_scene.get_node("Train")
var current_carriage = 1 setget set_current_carriage_ref
onready var current_carriage_ref = train.carriages[1]


func _ready():
# warning-ignore:return_value_discarded
	$HPBar.connect("timer_timeout", self, "_on_hp_timer_timeout")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("item_picked_up", self, "_on_item_picked_up")
	
	$StunTimer.wait_time = stun_time


func _process(_delta):
	if Input.is_action_pressed("Left_Click"): # in process so one can hold down button to fire
		# So we can hold shift and shoot 'enemy' bullets for debug
		if OS.is_debug_build():
			if Input.is_action_pressed("Shift") and not stunned:
				shoot(true)
			elif not stunned:
				shoot()
		elif $FiringTimer.is_stopped() and not stunned:
			shoot()


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


func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("Right_Click"):
			blink()
	if event is InputEventKey:
		if event.is_pressed() and $AmmoBar/Timer.is_stopped():
			if event.scancode == KEY_1:
				change_weapon(0)
			elif event.scancode == KEY_2:
				change_weapon(1)
			elif event.scancode == KEY_3:
				change_weapon(2)
			elif event.scancode == KEY_4:
				change_weapon(3)
			elif event.scancode == KEY_5:
				change_weapon(4)
			elif event.scancode == KEY_R:
				$AmmoBar/Timer.start()
			elif event.scancode == KEY_0 and OS.is_debug_build():
				print("Total ammo: " + str(current_weapon.total_ammo))
				print("HP: " + str(scaled_hp))

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	var direction = get_movement_input()

	if direction.length() > 0:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.playback_speed = 1
			$AnimationPlayer.play("walk")

		velocity = lerp(velocity, direction.normalized() * speed + current_carriage_ref.velocity, acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO + current_carriage_ref.velocity, friction)
		if $AnimationPlayer.current_animation == "walk":
			if $AnimationPlayer.current_animation_position >= 0.4:
				$AnimationPlayer.advance(0)
			else:
				$AnimationPlayer.advance(0.4)
			$AnimationPlayer.stop()

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


func _on_item_picked_up(item):
	get_tree().current_scene.spawned_items.erase(item) # Erase item from global item list
	match item.type:
		item.ItemType.POWER_UP:
			print('picked up: ' + str(item.display_name))
			pass
		item.ItemType.HEALTH:
			print('picked up: ' + str(item.display_name))
			$HPBar.visible = true
			if scaled_hp < 100:
				var scaled_health_increase = (float(item.value) / float(MAX_HP) * 100.0)
				if scaled_hp + scaled_health_increase > 100:
					scaled_hp = 100
				else:
					scaled_hp += scaled_health_increase
				$HPBar/Bar.value = scaled_hp
			else:
				scaled_hp = 100
				$HPBar/Timer.stop()
				$HPBar/Timer.start()
		item.ItemType.GUN:
			var gun_type_owned = null
			for i in $WeaponHandler.get_children():
				if i.filename == item.filename:
					print("Picked up " + str(item.total_ammo) + " " + item.display_name + " ammo.")
					gun_type_owned = i
					break
			if gun_type_owned == null:
				print('picked up: ' + str(item.display_name))
				var weapon_instance = load(item.filename).instance()
				weapon_instance.picked_up = true
				$WeaponHandler.call_deferred("add_child", weapon_instance)
				
				call_deferred("change_weapon", $WeaponHandler.get_child_count())
				$AmmoBar/Bar.value = 100
			else:
				gun_type_owned.total_ammo += item.total_ammo


func change_weapon(index):
	if index <= $WeaponHandler.get_child_count() - 1:
		if current_weapon != $WeaponHandler.get_child(index):
			for i in $WeaponHandler.get_children():
				i.set_visible(false)
			$AnimationPlayer.play("change_weapon")
			$AnimationPlayer.playback_speed = 7
			yield($AnimationPlayer, "animation_finished")
			$WeaponHandler.get_child(index).set_visible(true)
			current_weapon.saved_clip_size = clip_size # Save clip size of last weapon
			var new_weapon = $WeaponHandler.get_child(index)
			if new_weapon.saved_clip_size != null:
				clip_size = new_weapon.saved_clip_size
				var scaled_ammo = float(clip_size) / float(new_weapon.clip_size) * 100
				$AmmoBar/Bar.value = scaled_ammo
			else:
				clip_size = new_weapon.clip_size
			$AmmoBar/Timer.wait_time = new_weapon.reload_time
			current_weapon = new_weapon

func die():
	stunned = true
	modulate = Color(1.0, 1.0, 1.0, 0.6)
	$StunTimer.wait_time = stun_time
	$StunTimer.start()


func _on_StunTimer_timeout():
	stunned = false
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	scaled_hp = 100
	$HPBar/Bar.value = scaled_hp


func _on_hp_timer_timeout():
	$HPBar.visible = false


func set_current_carriage_ref(value):
	current_carriage = value
	current_carriage_ref = train.carriages[value]

