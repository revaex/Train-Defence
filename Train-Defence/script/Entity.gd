extends KinematicBody2D

class_name Entity

onready var current_weapon = $WeaponHandler.get_child(0)

export var speed = 180
export var friction = 0.2
export var acceleration = 0.1
var velocity = Vector2.ZERO

export var max_hp = 10 setget set_max_hp
onready var current_hp = max_hp setget set_current_hp
var item_damage_increase = 0

var clip_size setget set_clip_size
onready var reload_timer = $AmmoBar/Timer

func _ready():
# warning-ignore:return_value_discarded
	#$AmmoBar.connect("timer_timeout", self, "_on_reload_timer_timeout")
	reload_timer.wait_time = current_weapon.reload_time
	
	current_weapon.picked_up = true
	clip_size = current_weapon.clip_size
	
	$HPBar.initialize()
	$AmmoBar.initialize()

func increase_hp(value):
	if current_hp + value <= max_hp:
		self.current_hp += value
	else:
		self.current_hp = max_hp

func die():
	pass

func shoot(debug_shoot_as_enemy=false):
	if reload_timer.is_stopped() and $FiringTimer.is_stopped():
		if clip_size >= 1:
			#current_weapon.total_ammo -= 1
			self.clip_size -= 1
			if clip_size <= 0:
				reload()
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

func reload():
	reload_timer.start()
	$AmmoBar.start_tween(current_weapon.reload_time)

func _on_reload_timer_timeout():
	var temp_total_ammo = current_weapon.total_ammo
	current_weapon.total_ammo -= current_weapon.clip_size - clip_size
	if current_weapon.total_ammo < 0:
		current_weapon.total_ammo = 0
	self.clip_size += temp_total_ammo
	if clip_size > current_weapon.clip_size:
		self.clip_size = current_weapon.clip_size

func take_damage(dmg):
	self.current_hp -= dmg
	if current_hp <= 0:
		self.current_hp = 0
		die()

func set_max_hp(value):
	max_hp = value
	$HPBar.set_max_value(value)
	
func set_current_hp(value):
	current_hp = value
	$HPBar.set_value(value)

func set_clip_size(value):
	clip_size = value
	$AmmoBar.set_value(value)

