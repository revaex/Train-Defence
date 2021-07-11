extends Control



export (NodePath) onready var music_checkbox = get_node(music_checkbox)
export (NodePath) onready var music_slider = get_node(music_slider)
export (NodePath) onready var sfx_checkbox = get_node(sfx_checkbox)
export (NodePath) onready var sfx_slider = get_node(sfx_slider)
export (NodePath) onready var ambience_checkbox = get_node(ambience_checkbox)
export (NodePath) onready var ambience_slider = get_node(ambience_slider)
export (NodePath) onready var auto_switch_weapons_checkbox = get_node(auto_switch_weapons_checkbox)



func _ready():
	refresh_options()
	
func refresh_options():
	# Set sliders/checkboxes visual data to represent saved data
	for i in GlobalOptions.current_options:
		match i:
			"music_checkbox":
				music_checkbox.pressed = GlobalOptions.current_options[i]
			"music_slider":
				music_slider.value = GlobalOptions.current_options[i]
			"sfx_checkbox":
				sfx_checkbox.pressed = GlobalOptions.current_options[i]
			"sfx_slider":
				sfx_slider.value = GlobalOptions.current_options[i]
			"ambience_checkbox":
				ambience_checkbox.pressed = GlobalOptions.current_options[i]
			"ambience_slider":
				ambience_slider.value = GlobalOptions.current_options[i]
			"auto_switch_weapons_checkbox":
				auto_switch_weapons_checkbox.pressed = GlobalOptions.current_options[i]


func _on_Save_pressed():
	print("Saving...")
	# Save the data associated with the sliders/checkboxes into a dictionary
	var variable_options = {
		"music_checkbox": music_checkbox.pressed,
		"music_slider": music_slider.value,
		"sfx_checkbox": sfx_checkbox.pressed,
		"sfx_slider": sfx_slider.value,
		"ambience_checkbox": ambience_checkbox.pressed,
		"ambience_slider": ambience_slider.value,
		"auto_switch_weapons_checkbox": auto_switch_weapons_checkbox.pressed,
	}
	# If data has been changed, overwrite current_options dictionary with new data
	for i in GlobalOptions.current_options:
		if GlobalOptions.current_options[i] != variable_options[i]:
			print(i + " was changed to: " + str(variable_options[i]))
			GlobalOptions.current_options[i] = variable_options[i]
	GlobalOptions.save_options()
	GlobalSceneChange.goto_scene(GlobalSceneChange.scenes.MainMenu)

