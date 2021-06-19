extends CanvasLayer

var scroll_speed = 700

var embellishment = preload("res://scene/environment/Embellishment.tscn")

func _ready():
	pass
	#$Dirt.material.set_shader_param("speed_scale", scroll_speed)
	#$Track.material.set_shader_param("speed_scale", scroll_speed*3)

func _physics_process(delta):
	$ParallaxBackground/ParallaxLayer.motion_offset.x -= scroll_speed * delta
	$ParallaxBackground2/ParallaxLayer.motion_offset.x -= scroll_speed/1.5 * delta

func _on_SpawnEmbellishment_timeout():
	var new_decoration = embellishment.instance()
	new_decoration.position.x = 3460
	add_child(new_decoration)
	$SpawnEmbellishment.wait_time = rand_range(1.0, 4.0)
