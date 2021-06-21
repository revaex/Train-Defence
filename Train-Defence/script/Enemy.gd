extends KinematicBody2D

class_name Enemy

onready var current_weapon

const MAX_HP = 3 # EDIT THIS HP VARIABLE INITIALLY
var scaled_hp = 100 # handled internally

var shoot_range = 1000

var target_character = false
onready var character = get_tree().current_scene.get_node("Character")

var vec_to_connector
var vec_to_character

var rotation_speed = 0.1


var car = null # Reference to car enemy is riding

func _ready():
	randomize()
	current_weapon = load("res://scene/items/guns/Pistol.tscn").instance()
	current_weapon.picked_up = true
	current_weapon.position = $GunPosition.position
	call_deferred("add_child", current_weapon)
	
	$FiringTimer.set_wait_time(current_weapon.firing_rate + randf())

func _draw():
	if car.target != null and OS.is_debug_build():
		draw_line(to_local(global_position), to_local(car.target.get_node("Connector").global_position), Color(0.0,1.0,0.0,1.0))
		draw_line(to_local(global_position), to_local(character.global_position), Color(1.0,0.0,0.0,1.0))

func _process(_delta):
	$HPBarNode.global_rotation = 0
	shoot()
	
	
func _physics_process(delta):
	if car.target != null:
		update()
		vec_to_connector = to_local(car.target.get_node("Connector").global_position) - to_local(global_position)
		vec_to_character = to_local(character.global_position) - to_local(global_position)
		
		
		if vec_to_connector.length() < shoot_range:
			$RayCast2D.cast_to = vec_to_connector
			if $RayCast2D.is_colliding():
				var collider = $RayCast2D.get_collider()
				if collider.is_in_group("connectors"):
					look_at(car.target.get_node("Connector").global_position)
					#smooth_look_at(self, collider.global_position, delta)
				elif vec_to_character.length() < shoot_range:
					look_at(character.global_position)
					#smooth_look_at(self, character.global_position, delta)


func damage(dmg):
	print(str($RayCast2D.get_collider()))
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
	if $FiringTimer.is_stopped():
		$FiringTimer.set_wait_time(current_weapon.reload_time) # reset FiringTimer
		$FiringTimer.set_wait_time(current_weapon.reload_time + randf())
		$FiringTimer.start()
		var projectile_instance = load(current_weapon.projectile).instance()
		projectile_instance.damage = current_weapon.damage
		projectile_instance.speed = current_weapon.projectile_speed
		projectile_instance.transform = get_node(current_weapon.name + "/Position2D").global_transform
		projectile_instance.friendly = false
		get_tree().current_scene.add_child(projectile_instance)


func _on_Projectile_hit(projectile):
	damage(projectile.damage)


#-------------------------
func smooth_look_at( node_to_turn, target_position, turn_speed ):
	node_to_turn.rotate( deg2rad( _angular_look_at( node_to_turn.global_position, node_to_turn.global_rotation, target_position, turn_speed ) ) )
#-------------------------
# these are only called from above functions
func _angular_look_at( _currentPosition, _currentRotation, target_position, _turnTime ):
	return _get_angle( _currentRotation, _target_angle( _currentPosition, target_position ) )/_turnTime
func _target_angle( _currentPosition, target_position ):
	return (target_position - _currentPosition).angle()
func _get_angle( _currentAngle, _targetAngle ):
	return fposmod( _targetAngle - _currentAngle + PI, PI * 2 ) - PI
#-------------------------
