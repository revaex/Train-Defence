extends Node2D


onready var firing_timer = $FiringTimer


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
			Global.audio.playGunshot(owner.current_weapon.name)

func reload():
	owner.reload_timer.start()
	owner.get_node("AmmoBar").start_tween(owner.current_weapon.reload_time)

func change_weapon(index):
	if index <= get_child_count() - 1 and index != 0:
		if owner.current_weapon != get_child(index):
			for i in get_children():
				if not i is Timer:
					i.set_visible(false)
			owner.get_node("AnimationPlayer").play("change_weapon")
			owner.get_node("AnimationPlayer").playback_speed = 7
			yield(owner.get_node("AnimationPlayer"), "animation_finished")
			get_child(index).show()
			owner.current_weapon.saved_clip_size = owner.clip_size # Save clip size of last weapon
			owner.current_weapon = get_child(index) # Update current_weapon
			owner.get_node("AmmoBar").set_max_value(owner.current_weapon.clip_size)
			if owner.current_weapon.saved_clip_size != null:
				owner.clip_size = owner.current_weapon.saved_clip_size
			else:
				owner.clip_size = owner.current_weapon.clip_size
			owner.reload_timer.wait_time = owner.current_weapon.reload_time

func add_weapon(weapon):
	call_deferred("add_child", weapon)
	call_deferred("change_weapon", get_child_count())
