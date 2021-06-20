extends KinematicBody2D


onready var current_weapon

const MAX_HP = 3 # EDIT THIS HP VARIABLE INITIALLY
var scaled_hp = 100 # handled internally

var shoot_range = 350
var target_character = false

func _ready():
	randomize()
	current_weapon = load("res://scene/items/guns/Pistol.tscn").instance()
	current_weapon.picked_up = true
	current_weapon.position = $GunPosition.position
	call_deferred("add_child", current_weapon)
	
	$ReloadTimer.set_wait_time(current_weapon.reload_time + randf())
	
func _process(_delta):
	$HPBarNode.global_rotation = 0
	
	shoot()
	
func damage(dmg):
	var scaled_damage = (float(dmg) / float(MAX_HP) * 100.0)
	scaled_hp -= scaled_damage
	$HPBarNode.visible = true
	$HPBarNode/HPBar.value = scaled_hp
	if scaled_hp <= 0:
		die()


func die():
	GlobalEvents.emit_signal("enemy_dead", self)
	queue_free()


func shoot():
	if $ReloadTimer.is_stopped():
		$ReloadTimer.set_wait_time(current_weapon.reload_time) # reset reloadtimer
		$ReloadTimer.set_wait_time(current_weapon.reload_time + randf())
		$ReloadTimer.start()
		var projectile_instance = load(current_weapon.projectile).instance()
		get_tree().current_scene.add_child(projectile_instance)
		projectile_instance.damage = current_weapon.damage
		projectile_instance.transform = get_node(current_weapon.name + "/Position2D").global_transform
		projectile_instance.friendly = false


func _on_Projectile_hit(projectile):
	damage(projectile.damage)
