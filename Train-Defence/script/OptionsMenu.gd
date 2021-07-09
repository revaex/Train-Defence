extends Control


const OPTIONS_FILE = "user://options.json"

export (NodePath) onready var music_checkbox = get_node(music_checkbox)
export (NodePath) onready var music_slider = get_node(music_slider)
export (NodePath) onready var sfx_checkbox = get_node(sfx_checkbox)
export (NodePath) onready var sfx_slider = get_node(sfx_slider)
export (NodePath) onready var auto_switch_weapons_checkbox = get_node(auto_switch_weapons_checkbox)

# The default options that will be loaded if no save file exists
var current_options = {
	"music_checkbox": true,
	"music_slider": 50,
	"sfx_checkbox": true,
	"sfx_slider": 60,
	"auto_switch_weapons_checkbox": true,
}

func _ready():
	load_options()
	
	for i in current_options:
		match i:
			"music_checkbox":
				music_checkbox.pressed = current_options[i]
			"music_slider":
				music_slider.value = current_options[i]
			"sfx_checkbox":
				sfx_checkbox.pressed = current_options[i]
			"sfx_slider":
				sfx_slider.value = current_options[i]
			"auto_switch_weapons_checkbox":
				auto_switch_weapons_checkbox.pressed = current_options[i]

func save_options():
	var file = File.new()
	file.open(OPTIONS_FILE, File.WRITE)
	file.store_string(to_json(current_options))
	file.close()


func load_options():
	var file = File.new()
	if file.file_exists(OPTIONS_FILE):
		print("Loading existing save file...")
		file.open(OPTIONS_FILE, File.READ)
		var loaded_options = parse_json(file.get_as_text())
		assert(current_options.size() == loaded_options.size(), \
				"Disrepency between current_options (" + str(current_options.size()) + \
				") and loaded_options (" + str(loaded_options.size()) + ")"
		)
		for i in loaded_options:
			if loaded_options[i] != current_options[i]:
				current_options[i] = loaded_options[i]
	else:
		print("Creating new save file with default options...")
		save_options()
	file.close()


func _on_Save_pressed():
	var variable_options = {
		"music_checkbox": music_checkbox.pressed,
		"music_slider": music_slider.value,
		"sfx_checkbox": sfx_checkbox.pressed,
		"sfx_slider": sfx_slider.value,
		"auto_switch_weapons_checkbox": auto_switch_weapons_checkbox.pressed,
	}
	print("Saving...")
	for i in current_options:
		if current_options[i] != variable_options[i]:
			print(i + " was changed to: " + str(variable_options[i]))
			current_options[i] = variable_options[i]
	save_options()
	GlobalSceneChange.goto_scene(GlobalSceneChange.scenes.MainMenu)
