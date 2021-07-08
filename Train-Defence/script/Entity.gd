extends KinematicBody2D

class_name Entity

onready var current_weapon = $WeaponHandler.get_child(1)

export var speed = 180
export var friction = 0.2
export var acceleration = 0.1
var velocity = Vector2.ZERO

export var max_hp = 10 setget _set_max_hp
onready var current_hp = max_hp setget _set_current_hp
var item_damage_increase = 0

var clip_size setget _set_clip_size
onready var reload_timer = $AmmoBar/Timer

onready var exp_handler = $ExpHandler
export (bool) var can_gain_exp = false
export (int) var level = 1

func _ready():
# warning-ignore:return_value_discarded
	$AmmoBar.connect("timer_timeout", self, "_on_reload_timer_timeout")
	reload_timer.wait_time = current_weapon.reload_time
	
	current_weapon.picked_up = true
	clip_size = current_weapon.clip_size
	
	$HPBar.initialize()
	$AmmoBar.initialize()
	$ExpBar.initialize()

func increase_hp(value):
	if current_hp + value <= max_hp:
		self.current_hp += value
	else:
		self.current_hp = max_hp

func die():
	#$DeathParticles.global_position = global_position
	$DeathParticles.activate()

func _on_reload_timer_timeout():
	var temp_total_ammo = current_weapon.total_ammo
	current_weapon.total_ammo -= current_weapon.clip_size - clip_size
	if current_weapon.total_ammo < 0:
		current_weapon.total_ammo = 0
	self.clip_size += temp_total_ammo
	if clip_size > current_weapon.clip_size:
		self.clip_size = current_weapon.clip_size

func take_damage(dmg, shooter, incoming_direction):
	$BloodParticles.activate()
	$BloodParticles.direction = -incoming_direction
	
	self.current_hp -= dmg
	if current_hp <= 0:
		self.current_hp = 0
		shooter.gain_experience(level * 5)
		die()

func _set_max_hp(value):
	max_hp = value
	$HPBar.set_max_value(value)
	
func _set_current_hp(value):
	current_hp = value
	$HPBar.set_value(value)

func _set_clip_size(value):
	clip_size = value
	$AmmoBar.set_value(value)

func gain_experience(value):
	exp_handler.gain_experience(value)
	
func shoot(debug_shoot_as_enemy = false):
	$WeaponHandler.shoot(debug_shoot_as_enemy)

func reload():
	$WeaponHandler.reload()
	

