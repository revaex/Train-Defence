extends Node2D

var total_carriages = 12 # DON'T CHANGE UNTIL CarriageSpawner IS CREATED!!
var carriages = ["PADDING"] # So index starts at 1. (DISGUSTING, <PUKE>)

var carriage_buffer = 0
onready var leftmost_carriage = $Carriage1

func _ready():
# warning-ignore:return_value_discarded
	GlobalEvents.connect("train_connector_broken", self, "_on_train_connector_broken")
	
	for i in get_tree().get_nodes_in_group("carriages"):
		carriages.append(i)

func _on_train_connector_broken(index):
	var i_index = -1
	for i in carriages:
		i_index += 1
		if i_index == 0: # Skip padding so indicies start from 1
			continue
		if not i is String: # Carriage is replaced with a string when it dies
			if i.alive:
				if i_index <= index:
					if i_index == index: 
						i.break_right()
					lose_carriage(i)
				elif i_index == index + 1:
					i.break_left()
					break

func lose_carriage(carriage : Node):
	carriage.die()
	carriage_buffer += 1
	leftmost_carriage = carriages[1 + carriage_buffer]
	print("Total carriages left: " + str(owner.get_child_count()))
	
func lose_connector(connector : Node):
	connector.die()
