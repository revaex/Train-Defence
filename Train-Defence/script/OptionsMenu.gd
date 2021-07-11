extends Control

signal options_menu_closed()

# -------------------------- OPTIONS --------------------------
# IMPORTANT: When adding a checkbox option, it must contain "_checkbox" in its var name
export (NodePath) onready var music_checkbox = get_node(music_checkbox)
export (NodePath) onready var sfx_checkbox = get_node(sfx_checkbox)
export (NodePath) onready var ambience_checkbox = get_node(ambience_checkbox)
export (NodePath) onready var auto_switch_weapons_checkbox = get_node(auto_switch_weapons_checkbox)

# IMPORTANT: When adding a slider option, it must contain "_slider" in its var name
export (NodePath) onready var music_slider = get_node(music_slider)
export (NodePath) onready var sfx_slider = get_node(sfx_slider)
export (NodePath) onready var ambience_slider = get_node(ambience_slider)
# -----------------------------------------------------------

# option_items dictionary is populated via init_option_items() method
var option_items = {
	"checkbox": {},
	"slider": {},
}

func _ready():
	init_option_items()
	_refresh_options()

func _input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("Menu"):
			_overwrite_data()
			GlobalOptions.save_options()
			_handle_exit()

# Populate option_items dictionary "name":node pairs
func init_option_items():
	if option_items["checkbox"].size() == 0 and option_items["slider"].size() == 0:
		for i in get_property_list():
			if "_checkbox" in i.name:
				option_items["checkbox"][i.name] = get(i.name)
			elif "_slider" in i.name:
				option_items["slider"][i.name] = get(i.name)


# Set sliders/checkboxes visual data to represent saved data
func _refresh_options():
	for i in GlobalOptions.current_options:
		match i:
			"checkbox":
				for j in GlobalOptions.current_options[i]:
					option_items[i][j].pressed = GlobalOptions.current_options[i][j]
			"slider":
				for j in GlobalOptions.current_options[i]:
					option_items[i][j].value = GlobalOptions.current_options[i][j]


func _on_Save_pressed():
	_overwrite_data()
	GlobalOptions.save_options()
	_handle_exit()


func _on_Cancel_pressed():
	_handle_exit()


func _overwrite_data():
	# If data has been changed, overwrite GlobalOptions.current_options dictionary with new data
	for i in GlobalOptions.current_options:
		match i:
			"checkbox":
				for j in GlobalOptions.current_options[i]:
					if GlobalOptions.current_options[i][j] != option_items[i][j].pressed:
						print(str(j) + " was changed to: " + str(option_items[i][j].pressed))
						GlobalOptions.current_options[i][j] = option_items[i][j].pressed
			"slider":
				for j in GlobalOptions.current_options[i]:
					if GlobalOptions.current_options[i][j] != option_items[i][j].value:
						print(str(j) + " was changed to: " + str(option_items[i][j].value))
						GlobalOptions.current_options[i][j] = option_items[i][j].value
	print("Saving...")


func _handle_exit():
	# Use the root viewport to distinguish between accessing scene from the 
	# main menu vs in-game menu
	if get_parent() == get_tree().root:
		GlobalSceneChange.goto_scene(GlobalSceneChange.scenes.MainMenu)
	else:
		emit_signal("options_menu_closed")

