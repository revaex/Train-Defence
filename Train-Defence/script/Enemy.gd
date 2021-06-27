extends Entity

class_name Enemy


var shoot_range = 400

var target_character = false
onready var character = get_tree().current_scene.get_node("Character")

var vec_to_connector
var vec_to_character

var rotation_speed = 0.15 # Lower value = slower

var target = null #get_tree().current_scene.get_node("Character")

var car = null # Reference to car enemy is riding

func _ready():
	randomize()
	
	$FiringTimer.set_wait_time(current_weapon.firing_rate + randf())


func _process(_delta):
	
	if OS.is_debug_build():
		if Input.is_action_pressed("ui_right"):
			car.position.x += 1
		if Input.is_action_pressed("ui_left"):
			car.position.x -= 1
		if Input.is_action_pressed("ui_accept"):
			print(self.name + ": " + str(rad2deg(get_angle_to(to_local(car.target.global_position)))))
	
	
func _physics_process(_delta):
	if car.target != null and is_instance_valid(car.target):
		vec_to_connector = to_local(car.target.global_position) - to_local(global_position)
		vec_to_character = to_local(character.global_position) - to_local(global_position)
		
		$RayCast2D.cast_to = vec_to_connector
		if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if collider.is_in_group("connectors"):
				if vec_to_connector.length() < shoot_range:
					self.target = collider
			elif vec_to_character.length() < shoot_range:
				self.target = character
			else:
				self.target = null
				global_rotation = lerp_angle(global_rotation, 0.0, rotation_speed)
				
	if is_instance_valid(target):
		smooth_look_at(self, target.global_position, rotation_speed)
		shoot()


func die():
	GlobalEvents.emit_signal("enemy_dead", self)
	queue_free()


func _on_reload_timer_timeout():
	._on_reload_timer_timeout()
	clip_size = current_weapon.clip_size # Give enemy unlimited ammo

#-------------------------
func smooth_look_at( node_to_turn, target_position, turn_speed ):
	node_to_turn.rotate( deg2rad( _angular_look_at( node_to_turn.global_position, node_to_turn.global_rotation, target_position, turn_speed ) ) )
#
# The following three functions are only called from smooth_look_at()
#
func _angular_look_at( _currentPosition, _currentRotation, _target_position, _turnTime ):
	return _get_angle( _currentRotation, _target_angle( _currentPosition, _target_position ) )/_turnTime
func _target_angle( _currentPosition, _target_position ):
	return (_target_position - _currentPosition).angle()
func _get_angle( _currentAngle, _targetAngle ):
	return fposmod( _targetAngle - _currentAngle + PI, PI * 2 ) - PI
#-------------------------
