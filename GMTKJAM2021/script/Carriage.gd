extends KinematicBody2D

var speed = 110
var acceleration = 0.1
var velocity = Vector2.ZERO
var alive = true

func _ready():
	get_parent().carriages.append(self)

func _physics_process(_delta):
	if !alive:
		var direction = Vector2(-1,0)
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
		velocity = move_and_slide(velocity)
		
		var padding = 100
		if get_global_transform().origin.x < 0 - $Sprite.texture.get_size().x / 2 - padding:
			owner.remove_child(self)
	return
	
func break_right():
	$Broken_Connector_R.visible = true
	return
	
func break_left():
	$Broken_Connector_L.visible = true
	return
	
func die():
	alive = false
	return

