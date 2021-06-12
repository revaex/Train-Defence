extends KinematicBody2D


onready var current_weapon = load("res://scene/entities/Gun.tscn").instance()

func _ready():
	pass
	
func _process(delta):
	shoot()


func shoot():
	if $ReloadTimer.is_stopped():
		$ReloadTimer.start()
		var projectile_instance = load(current_weapon.projectile).instance()
		get_tree().current_scene.add_child(projectile_instance)
		projectile_instance.damage = current_weapon.damage
		projectile_instance.transform = $Gun/Position2D.global_transform
		projectile_instance.friendly = false
