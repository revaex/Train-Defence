extends KinematicBody2D


onready var current_weapon = load("res://scene/entities/Gun.tscn").instance()
const MAX_HP = 3 # EDIT THIS HP VARIABLE INITIALLY
var scaled_hp = 100 # handled internally


func _ready():
	pass
	
func _process(delta):
	$HPBarNode.global_rotation = 0
	
	shoot()
	
func damage(dmg : int):
	var scaled_damage = (float(dmg) / float(MAX_HP) * 100.0)
	scaled_hp -= scaled_damage
	$HPBarNode.visible = true
	$HPBarNode/HPBar.value = scaled_hp
	if scaled_hp <= 0:
		die()


func die():
	queue_free()


func shoot():
	if $ReloadTimer.is_stopped():
		$ReloadTimer.start()
		var projectile_instance = load(current_weapon.projectile).instance()
		get_tree().current_scene.add_child(projectile_instance)
		projectile_instance.damage = current_weapon.damage
		projectile_instance.transform = $Gun/Position2D.global_transform
		projectile_instance.friendly = false


func _on_Projectile_hit(projectile):
	damage(projectile.damage)
	projectile.queue_free()
