extends KinematicBody2D

class_name Entity

onready var current_weapon = $WeaponHandler.get_child(0)

var speed = 180
var friction = 0.2
var acceleration = 0.1
var velocity = Vector2.ZERO

var MAX_HP = 10
var scaled_hp = 100
var item_damage_increase = 0

var clip_size

func _ready():
# warning-ignore:return_value_discarded
	$AmmoBar.connect("timer_timeout", self, "_on_reload_timer_timeout")
	current_weapon.picked_up = true
	$AmmoBar/Timer.wait_time = current_weapon.reload_time
	clip_size = current_weapon.clip_size

func _process(_delta):
	if not $AmmoBar/Timer.is_stopped():
		# Reloading
		var scaled_reload = (float($AmmoBar/Timer.time_left) / float(current_weapon.reload_time) * 100.0)
		$AmmoBar/Bar.value = 100-scaled_reload

func die():
	pass

func shoot(debug_shoot_as_enemy=false):
	if $AmmoBar/Timer.is_stopped() and $FiringTimer.is_stopped():
		if clip_size >= 1:
			clip_size -= 1
			current_weapon.total_ammo -= 1
			var scaled_ammo = float(clip_size) / float(current_weapon.clip_size) * 100
			$AmmoBar/Bar.value = scaled_ammo
			if clip_size <= 0:
				# Reload
				$AmmoBar/Timer.start()
			var projectile_instance = load(current_weapon.projectile).instance()
			projectile_instance.damage = current_weapon.damage + item_damage_increase
			projectile_instance.transform = $WeaponHandler.get_child(current_weapon.get_index()).get_node("TipOfBarrel").global_transform
			projectile_instance.speed = current_weapon.projectile_speed
			projectile_instance.shooter = self
			if debug_shoot_as_enemy and OS.is_debug_build():
				projectile_instance.debug_shoot_as_enemy = true
			get_tree().current_scene.add_child(projectile_instance)
			$FiringTimer.set_wait_time(current_weapon.firing_rate)
			$FiringTimer.start()
			Global.audio.playGunshot(current_weapon.name)

func take_damage(dmg):
	var scaled_damage = (float(dmg) / float(MAX_HP) * 100.0)
	scaled_hp -= scaled_damage
	$HPBar.visible = true
	$HPBar/Bar.value = scaled_hp
	if scaled_hp <= 0:
		die()

func _on_reload_timer_timeout():
	if current_weapon.total_ammo > current_weapon.clip_size:
		clip_size = current_weapon.clip_size
	else:
		clip_size = current_weapon.total_ammo
	$AmmoBar/Bar.value = 100
