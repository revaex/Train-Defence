extends KinematicBody2D

var speed = 110
var acceleration = 0.1
var velocity = Vector2.ZERO
var alive = true
onready var index = name.rsplit("Carriage", false)[0] as int

onready var connector = $Connector

func _physics_process(delta):
	if !alive:
		var direction = Vector2(-1,0)
		velocity = lerp(velocity, direction.normalized() * speed, acceleration)
		translate(velocity * delta)
		
		var padding = 100
		if get_global_transform().origin.x < 0 - $Sprite.texture.get_size().x / 2 - padding:
			GlobalEvents.emit_signal("carriage_died", self, index)
			owner.carriages[index] = "DEAD_CARRIAGE" 
			owner.remove_child(self)
	
func break_right():
	$Broken_Connector_R.visible = true
	
func break_left():
	$Broken_Connector_L.visible = true
	
func die():
	alive = false

