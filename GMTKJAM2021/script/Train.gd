extends Node2D

var carriages = []

func _ready():
	for i in get_children():
		if i.is_in_group("carriages"):
			carriages.append(i)

func lose_carriages(connector):
	if connector > 0 and connector < 12:
		for i in get_children():
			if i.is_in_group("carriages"):
				var carriage_num = i.name.rsplit("Carriage", false)[0] as int
				if carriage_num <= connector:
					if carriage_num == connector: 
						break_carriage_right(i)
					lose_carriage(i)
				elif carriage_num == connector+1:
					break_carriage_left(i)
			elif i.is_in_group("connectors"):
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
	carriages.erase(carriage)
	print("Total carriages " + str(carriages.size()))
	return
	
func lose_connector(connector : Node):
	connector.die()
	return
