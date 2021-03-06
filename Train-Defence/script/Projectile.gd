extends Area2D

class_name Projectile

# The following are handled/set by the shooter
var speed # Set to shooters current weapon speed
var damage  # Set to shooters current weapon damage
var shooter # A reference to the shooter

# Set only once when ready. To avoid shooting a rocket, then changing to a pistol
# and having the collision think it came from a pistol
var shooter_position
var shooter_weapon_name

# Determines the bounding box (using center of the screen as origin) for projectiles to be free'd from memory
onready var bounds = get_viewport().size

# Debug feature to enable character to shoot as if he was an enemy
var debug_shoot_as_enemy = false 

func _ready():
	if shooter is Enemy or debug_shoot_as_enemy:
		_init_enemy_collision()
	
	if is_instance_valid(shooter):
		shooter_position = shooter.position
		shooter_weapon_name = shooter.current_weapon.name

func _init_enemy_collision():
	set_collision_layer_bit(6, false) # Disable 'friendly_projectile" layer
	set_collision_layer_bit(8, true) # Enable 'enemy_projectile' layer
	set_collision_mask_bit(4, false) # Disable 'enemy' mask
	set_collision_mask_bit(2, true) # Enable 'connectors' mask
	set_collision_mask_bit(3, true) # Enable 'character' mask

func _physics_process(delta):
	position += transform.x * speed * delta

	# Treating the viewport origin as the center of the screen for convenience
	var vp_transform = get_viewport_transform().origin
	var vp_size = get_viewport().size
	if position.x < -vp_transform.x + vp_size.x/2 - bounds.x or position.x > -vp_transform.x - vp_size.x/2+ bounds.x*2 or \
			position.y < vp_transform.y + vp_size.y/2 - bounds.y or position.y > vp_transform.y - vp_size.y/2 + bounds.y*2:
		queue_free()

func _on_Projectile_body_entered(body):
	if not body is Car: # Bullets should go 'over' the cars
		body.take_damage(damage, shooter, (shooter_position - body.position).normalized())
		if shooter_weapon_name == "RocketLauncher":
			GlobalAudio.play(GlobalAudio.sounds.Explosion)
		queue_free()
