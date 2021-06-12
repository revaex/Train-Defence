extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func lose_carriages(connector):
	if connector > 0 and connector < 12:
		for i in get_children():
			if i.name.begins_with("Carriage"):
				var carriage_num = i.name.rsplit("Carriage", false)[0] as int
				if carriage_num <= connector:
					if carriage_num == connector: 
						break_carriage_right(i)
					lose_carriage(i)
				elif carriage_num == connector+1:
					break_carriage_left(i)
			elif i.name.begins_with("Connector"):
				if i.name.rsplit("Connector", false)[0] as int < connector:
					lose_connector(i)
	return

func break_carriage_right(carriage : Node):
	carriage.break_right()
	return
	
func break_carriage_left(carriage : Node):
	carriage.break_left()
	return

func lose_carriage(carriage : Node):
	carriage.die()
	return
	
func lose_connector(connector : Node):
	connector.die()
	return
