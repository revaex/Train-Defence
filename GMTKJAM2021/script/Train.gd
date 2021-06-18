extends Node2D

var carriages = ["PADDING"] # So index starts at 1.
var carriage_buffer = 0

func _ready():
	pass

func lose_carriages(connector):
	if connector > 0 and connector < 12:
		var tmp_index = -1
		for i in carriages:
			tmp_index += 1
			if tmp_index == 0: # Skip padding so indicies start from 1
				continue
			if not i is String: # Carriage is replaced with a string when it dies
				if i.alive:
					if tmp_index <= connector:
						if tmp_index == connector: 
							i.break_right()
						lose_carriage(i)
					elif tmp_index == connector + 1:
						i.break_left()


func lose_carriage(carriage : Node):
	carriage.die()
	#carriages[carriages.find(carriage)] = "DEAD_CARRIAGE"
	carriage_buffer += 1
	print("Total carriages left: " + str(carriages.size()))
	
func lose_connector(connector : Node):
	connector.die()
