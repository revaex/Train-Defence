extends Panel


export (NodePath) onready var character_marker = get_node(character_marker)
export (NodePath) onready var item_marker_placeholder = get_node(item_marker_placeholder)
export (NodePath) onready var hb = get_node(hb)

# Carriage_N = carriage_markers[N-1]
var carriage_markers = [] # An array of $HB/Carriage1, $HB/Carriage2, etc
var items = [] # A copy of the spawned items array
var item_markers = [] # item_markers[n] -> item[n]'s item_marker

onready var character : Character = get_tree().current_scene.get_node("Character")
onready var char_pos_old = character.global_position # Used to detect character movement in _process

onready var train = get_tree().current_scene.get_node("Train")
onready var carriage_pos_old = [] # An array of stored carriage positions

# ratio_scale pixels moved in the "game-world" is 1 pixel moved in the "map world"
onready var ratio_scale = character.get_node("Camera2D").limit_right / hb.rect_size.x
onready var hb_seperation = hb.get("custom_constants/separation")

func _ready():
# warning-ignore:return_value_discarded
	GlobalEvents.connect("item_picked_up", self, "_on_item_picked_up")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("character_moved_carriage", self, "_on_character_moved_carriage")
	
	var temp_index = 0
	for i in hb.get_children():
		temp_index += 1
		carriage_markers.append(i)
		carriage_pos_old.append(train.carriages[temp_index].global_position)
	
	#$ItemMarker.rect_position = carriage_markers[1].rect_position + hb.rect_position + Vector2(hb_seperation,0) + carriage_markers[1].rect_size/2 - $ItemMarker.rect_size/2
	#character_marker.rect_position = carriage_markers[0].rect_position + Vector2(-carriage_markers[0].rect_position.x + hb_seperation, hb.rect_position.y) + carriage_markers[0].rect_size / 2 - character_marker.rect_size / 2
	character_marker.rect_position =  carriage_markers[0].rect_size / 2 - character_marker.rect_size / 2 - Vector2(1,-1)

	yield(get_tree().current_scene, "ready")
	for i in get_tree().current_scene.item_spawner.spawned_items:
		items.append(i)
		var new_rect = ColorRect.new()
		new_rect.color = item_marker_placeholder.color
		new_rect.rect_size = item_marker_placeholder.rect_size
		#new_rect.rect_position = carriage_markers[i.on_carriage - 1].rect_position + hb.rect_position + carriage_markers[i.on_carriage - 1].rect_size / 2 + i.position / ratio_scale - new_rect.rect_size / 2
		var carriage = carriage_markers[i.on_carriage-1]
		carriage.add_child(new_rect)
		new_rect.rect_position = i.position / ratio_scale + carriage.rect_size / 2 - new_rect.rect_size / 2#
		item_markers.append(new_rect)
		

func _process(_delta):
	# Character position (while carriage hes on is alive)
	if train.carriages[carriage_markers.find(character_marker.get_parent()) + 1].alive:
		var char_pos = character.global_position
		var diff = char_pos - char_pos_old
		if character_marker != null and ((diff < Vector2(50,50) and diff >= Vector2.ZERO) or (diff > Vector2(-50,-50) and diff <= Vector2.ZERO)):
			character_marker.rect_position += diff / ratio_scale
		char_pos_old = char_pos
	
	for i in train.carriages:
		if not i is String:
			if not i.alive and carriage_markers[i.index - 1].rect_position.x > -20 - carriage_markers[i.index - 1].rect_size.x / 2:
				# Handle carriage position
				var carriage_pos = i.global_position
				var diff2 = carriage_pos - carriage_pos_old[i.index - 1]
				carriage_markers[i.index - 1].rect_position += diff2 / ratio_scale
				carriage_pos_old[i.index - 1] = carriage_pos
				
				# Handle character position
				if character.current_carriage == i.index:
					var char_pos = character.global_position
					var diff = char_pos - char_pos_old
					if character_marker != null and ((diff < Vector2(50,50) and diff >= Vector2.ZERO) or (diff > Vector2(-50,-50) and diff <= Vector2.ZERO)):
						character_marker.rect_position += (diff - diff2) / ratio_scale
					char_pos_old = char_pos

func _on_item_picked_up(item):
	var item_index = items.find(item)
	var carriage = carriage_markers[item.on_carriage-1]
	carriage.remove_child(item_markers[item_index])
	item_markers.remove(item_index)
	items.erase(item)

func _on_character_moved_carriage(index):
	character_marker.get_parent().remove_child(character_marker)
	carriage_markers[index - 1].add_child(character_marker)
	character_marker.rect_position =  carriage_markers[index - 1].rect_size / 2 - character_marker.rect_size / 2 - Vector2(1,-1)
