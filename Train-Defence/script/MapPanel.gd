extends Panel


export (NodePath) onready var character_marker = get_node(character_marker)
export (NodePath) onready var item_marker_placeholder = get_node(item_marker_placeholder)
export (NodePath) onready var car_marker_placeholder = get_node(car_marker_placeholder)
export (NodePath) onready var hb = get_node(hb)
export (NodePath) onready var car_control = get_node(car_control)
export (NodePath) onready var flashing_tween = get_node(flashing_tween)

# Carriage_N = carriage_markers[N-1]
var carriage_markers = [] # An array of $HB/Carriage1, $HB/Carriage2, etc
var carriage_flash_count = [] # An array of values determining each carriages flash counter
var carriage_flash_timers = [] # An array of timers to time each carriages flashes

export var max_flashes = 10 # Each in/out counts as a single flash, so max_flashes/2 is the real flash count
export var flash_time = 0.25 # Time the tween takes to change the carriage's flash colour
export var flash_colour = Color.firebrick
export var dead_colour = Color.indianred

var items = [] # A copy of the spawned items array
var item_markers = [] # item_markers[n] -> item[n]'s item_marker

var cars = []
var car_markers = []

onready var character : Character = get_tree().current_scene.get_node("Character")
onready var char_pos_old = character.global_position # Used to detect character movement in _process

onready var train = get_tree().current_scene.get_node("Train")
onready var carriage_pos_old = [] # An array of stored carriage positions

onready var car_spawner = get_tree().current_scene.get_node("CarSpawner")
onready var car_pos_old = []

# ratio_scale pixels moved in the "game-world" is 1 pixel moved in the "map world"
onready var scale = 3190 / hb.rect_size.x


func _ready():
# warning-ignore:return_value_discarded
	GlobalEvents.connect("item_spawned", self, "_on_item_spawned")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("item_picked_up", self, "_on_item_picked_up")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("character_changed_carriage", self, "_on_character_changed_carriage")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("car_spawned", self, "_on_car_spawned")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("car_despawned", self, "_on_car_despawned")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("carriage_died", self, "_on_carriage_died")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("train_connector_damaged", self, "_on_train_connector_damaged")
	
	var temp_index = 0
	for i in hb.get_children():
		temp_index += 1
		carriage_markers.append(i)
		carriage_pos_old.append(train.carriages[temp_index].global_position)
		carriage_flash_count.append(0) # Will increase by 1 everytime a flash occurs
		var timer = Timer.new()
		timer.one_shot = false
		timer.wait_time = flash_time
		carriage_flash_timers.append(timer)
		add_child(timer)
		carriage_flash_timers[carriage_flash_timers.size()-1].connect("timeout", self, "_on_carriage_flash_timer_timeout", [carriage_flash_timers[carriage_flash_timers.size()-1]])
	
	character_marker.rect_position =  carriage_markers[0].rect_size / 2 - character_marker.rect_size / 2 - Vector2(1,-1)

# The worlds grossest _process function... So many loops...
func _process(_delta):
	# Car position
	var car_index = 0
	for i in cars:
		var car_pos = i.global_position
		var diff = car_pos - car_pos_old[car_index]
		car_markers[car_index].rect_position += diff / scale
		car_pos_old[car_index] = car_pos
		car_index += 1
	
	# Character position (while carriage hes on is alive)
	if train.carriages[carriage_markers.find(character_marker.get_parent()) + 1].alive:
		var char_pos = character.global_position
		var diff = char_pos - char_pos_old
		if character_marker != null and ((diff < Vector2(50,50) and diff >= Vector2.ZERO) or (diff > Vector2(-50,-50) and diff <= Vector2.ZERO)):
			character_marker.rect_position += diff / scale
		char_pos_old = char_pos
	
	# Character/carriage posittion when carriage is dead
	for i in train.carriages:
		if not i is String: # "train.carriages" values become "DEAD_CARRIAGE" when carriages die
			# Handle carriage position
			var carriage_pos = i.global_position
			var diff = carriage_pos - carriage_pos_old[i.index - 1]
			carriage_markers[i.index - 1].rect_position += diff / scale
			carriage_pos_old[i.index - 1] = carriage_pos
			
			# Handle character position
			if character.current_carriage == i.index:
				var char_pos = character.global_position
				var diff2 = char_pos - char_pos_old
				if character_marker != null and ((diff2 < Vector2(50,50) and diff2 >= Vector2.ZERO) or (diff2 > Vector2(-50,-50) and diff2 <= Vector2.ZERO)):
					character_marker.rect_position += (diff2 - diff) / scale
				char_pos_old = char_pos

func _on_item_spawned(item):
	items.append(item)
	var new_rect = ColorRect.new()
	new_rect.color = item_marker_placeholder.color
	new_rect.rect_size = item_marker_placeholder.rect_size
	if item.on_carriage != null:
		var carriage = carriage_markers[item.on_carriage-1]
		carriage.add_child(new_rect)
		new_rect.rect_position = item.position / scale + carriage.rect_size / 2 - new_rect.rect_size / 2
	else:
		# Items directly dragged to the game scene don't have a carriage
		car_control.add_child(new_rect)
		new_rect.rect_position = item.position / scale - new_rect.rect_size / 2
	item_markers.append(new_rect)

func _on_item_picked_up(item):
	var item_index = items.find(item)
	if item.on_carriage != null:
		var carriage = carriage_markers[item.on_carriage-1]
		carriage.remove_child(item_markers[item_index])
	else:
		car_control.remove_child(item_markers[item_index])
	item_markers.remove(item_index)
	items.erase(item)

func _on_character_changed_carriage(index):
	character_marker.get_parent().remove_child(character_marker)
	carriage_markers[index - 1].add_child(character_marker)
	character_marker.rect_position =  carriage_markers[index - 1].rect_size / 2 - character_marker.rect_size / 2 - Vector2(1,-1)

func _on_car_spawned(car):
	cars.append(car)
	var new_rect = ColorRect.new()
	new_rect.color = car_marker_placeholder.color
	new_rect.rect_size = car_marker_placeholder.rect_size
	car_control.add_child(new_rect)
	new_rect.rect_position = car.global_position / scale - new_rect.rect_size
	car_markers.append(new_rect)
	car_pos_old.append(car.global_position)

func _on_car_despawned(car):
	var car_index = cars.find(car)
	car_control.remove_child(car_markers[car_index])
	car_markers.remove(car_index)
	car_pos_old.remove(car_index)
	cars.erase(car)

func _on_carriage_died(_carriage, index):
	# To prevent the carriage positions from 'stacking-up' and becoming viewable
	carriage_markers[index - 1].rect_position.x = -45

func _on_train_connector_damaged(index):
	if not train.carriages[index].alive:
		for i in train.carriages:
			if not i is String:
				if i.index <= index and carriage_markers[i.index - 1].self_modulate != dead_colour:
					flashing_tween.interpolate_property(carriage_markers[i.index-1], "self_modulate", self_modulate, dead_colour, 0.5,Tween.TRANS_SINE, Tween.EASE_IN)
					flashing_tween.start()
	else:
		carriage_flash_timers[index - 1].start()
		carriage_flash_count[index - 1] = 0

func _on_carriage_flash_timer_timeout(timer):
	var index = carriage_flash_timers.find(timer)
	carriage_flash_count[index] += 1
	if carriage_flash_count[index] > max_flashes or not train.carriages[index+1].alive:
		carriage_flash_timers[index].stop()
		carriage_flash_count[index] = 0
		carriage_markers[index].self_modulate = Color.white
		return
	if carriage_markers[index].self_modulate == flash_colour:
		flashing_tween.interpolate_property(carriage_markers[index], "self_modulate", flash_colour, Color.white, flash_time-0.1,Tween.TRANS_SINE, Tween.EASE_IN)
		flashing_tween.start()
	elif carriage_markers[index].self_modulate == Color.white:
		flashing_tween.interpolate_property(carriage_markers[index], "self_modulate", Color.white, flash_colour, flash_time-0.1,Tween.TRANS_SINE, Tween.EASE_IN)
		flashing_tween.start()

