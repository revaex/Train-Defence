extends KinematicBody2D

var speed = 90
var acceleration = 0.1
var velocity = Vector2.ZERO
var alive = true

func _physics_process(delta):
	if !alive:
		var direction = Vector2(-1,0)
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
		velocity = move_and_slide(velocity)
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
