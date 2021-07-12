extends Control

signal options_menu_closed()

# -------------------------- OPTIONS --------------------------
# To add a new option, copy the variable structure below
# For option to actually take effect, include it in GlobalOptions.options_take_effect()

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
#	"checkbox": {
#		"music_checkbox": [Node:1337]
#	},
#	"slider": {
#		"music_slider": [Node:1338]
#	},
}

# Contains the category, property and default value
var options = {
	"checkbox": {
		"property": "pressed",
		"default": true,
	},
	"slider": {
		"property": "value",
		"default": 0.5,
	},
}

func _ready():
	init_option_items()
	_refresh_options()

func _input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("Menu"):
			_handle_exit()


func init_option_items():
	# Populate option_items dictinoary with values from options dictionary
	for i in options:
		option_items[i] = {}
	# Iterating get_property_list() is inefficient so we only want to do it once
	for i in option_items.keys():
		if option_items[i].size() != 0:
			return
	for i in get_property_list():
		if i.usage == 8199: # Make sure we are only checking exported variables
			for j in option_items.keys():
				if ("_" + j) in i.name:
					# Populate option_items dictionary "name":node pairs
					option_items[j][i.name] = get(i.name)


# Set sliders/checkboxes visual data to represent saved data
func _refresh_options():
	for i in GlobalOptions.current_options:
		for j in GlobalOptions.current_options[i]:
				option_items[i][j].set(options[i]["property"], GlobalOptions.current_options[i][j])


func _on_Save_pressed():
	_overwrite_data()
	GlobalOptions.save_options()
	_handle_exit()


func _on_Cancel_pressed():
	_handle_exit()


func _overwrite_data():
	# If data has been changed, overwrite GlobalOptions.current_options dictionary with new data
	for i in GlobalOptions.current_options:
		for j in GlobalOptions.current_options[i]:
			if GlobalOptions.current_options[i][j] != option_items[i][j].get(options[i]["property"]):
				print(str(j) + " was changed to: " + str(option_items[i][j].get(options[i]["property"])))
				GlobalOptions.current_options[i][j] = option_items[i][j].get(options[i]["property"])
	print("Saving...")


func _handle_exit():
	# Use the root viewport to distinguish between accessing scene from the main menu vs in-game menu
	if get_parent() == get_tree().root:
		GlobalSceneChange.goto_scene(GlobalSceneChange.scenes.MainMenu)
	else:
		emit_signal("options_menu_closed")

