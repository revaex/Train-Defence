extends Node2D


onready var firing_timer = owner.get_node("FiringTimer")


func shoot(debug_shoot_as_enemy=false):
	if owner.reload_timer.is_stopped() and firing_timer.is_stopped():
		if owner.clip_size >= 1:
			owner.clip_size -= 1
			if owner.clip_size <= 0:
				reload()
			var projectile_instance = load(owner.current_weapon.projectile).instance()
			projectile_instance.damage = owner.current_weapon.damage + owner.item_damage_increase
			projectile_instance.transform = get_child(owner.current_weapon.get_index()).get_node("TipOfBarrel").global_transform
			projectile_instance.speed = owner.current_weapon.projectile_speed
			projectile_instance.shooter = owner
			if debug_shoot_as_enemy and OS.is_debug_build():
				projectile_instance.debug_shoot_as_enemy = true
			get_tree().current_scene.add_child(projectile_instance)
			firing_timer.set_wait_time(owner.current_weapon.firing_rate)
			firing_timer.start()
			GlobalAudio.play(GlobalAudio.sounds[owner.current_weapon.display_name])
			var particles = owner.current_weapon.get_node("CPUParticles2D")
			particles.emitting = true


func reload():
	owner.reload_timer.start()
	owner.get_node("AmmoBar").start_tween(owner.current_weapon.reload_time)


func change_weapon(index):
	if index >= 0 and index <= get_child_count() - 1:
		if owner.current_weapon != get_child(index):
			for i in get_children():
				i.hide()
			owner.get_node("AnimationPlayer").play("change_weapon")
			owner.get_node("AnimationPlayer").playback_speed = 10
			yield(owner.get_node("AnimationPlayer"), "animation_finished")
			get_child(index).show()
			owner.current_weapon.saved_clip_size = owner.clip_size # Save clip size of last weapon
			owner.current_weapon = get_child(index) # Update current_weapon
			GlobalEvents.emit_signal("changed_weapons", owner.current_weapon)
			owner.get_node("AmmoBar").set_max_value(owner.current_weapon.clip_size)
			if owner.current_weapon.saved_clip_size != null:
				owner.clip_size = owner.current_weapon.saved_clip_size
			else:
				owner.clip_size = owner.current_weapon.clip_size
			owner.reload_timer.wait_time = owner.current_weapon.reload_time


func add_weapon(item):
	# The engine throws an error ("area_set_shape_disabled") if I don't use call_deferred
	# All of the add_weapon code has been moved to the add_child override
	call_deferred("add_child", item)


# Overriding add_child to deal with call_deferred on weapon pick-up
func add_child(item, legible_unique_name=false):
	var gun_type_owned = null
	for i in get_children():
		if i.filename == item.filename:
			gun_type_owned = i
			break
	if gun_type_owned == null:
		# Picked up weapon for the first time, new weapon added
		GlobalEvents.emit_signal("item_picked_up_loot_panel", item, false)
		print('picked up: ' + str(item.display_name))
		var weapon_instance = load(item.filename).instance()
		weapon_instance.picked_up = true
		GlobalEvents.emit_signal("new_weapon_picked_up", weapon_instance)
		.add_child(weapon_instance, legible_unique_name)
		weapon_instance.hide()
		if GlobalOptions.current_options["checkbox"]["auto_switch_weapons_checkbox"]:
			change_weapon(get_child_count()-1)
	else:
		# Already had weapon, so ammo given instead
		print("Picked up " + str(item.total_ammo) + " " + item.display_name + " ammo.")
		gun_type_owned.total_ammo += item.total_ammo
		GlobalEvents.emit_signal("update_ammo_label")
		GlobalEvents.emit_signal("item_picked_up_loot_panel", item, item.total_ammo)


func get_weapon_index(weapon):
	return weapon.get_position_in_parent()


