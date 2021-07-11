extends Node


const OPTIONS_FILE = "user://options.json"


# The default options that will be loaded if no save file exists
var current_options = {
	"music_checkbox": true,
	"music_slider": 50,
	"sfx_checkbox": true,
	"sfx_slider": 50,
	"ambience_checkbox": true,
	"ambience_slider": 50,
	"auto_switch_weapons_checkbox": true,
}

func _ready():
	load_options()
	options_take_effect()


# Actually grant the desired effects (changing volume etc)
func options_take_effect():
	pass


# Overwrite OPTIONS_FILE with the current_options dictionary
func save_options():
	var file = File.new()
	file.open(OPTIONS_FILE, File.WRITE)
	file.store_string(to_json(current_options))
	file.close()
	options_take_effect()


# Overwrite the current_options dictionary with the OPTIONS_FILE json data.
# If OPTIONS_FILE doesn't exist, create it using default data from current_options
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
