extends Node


const OPTIONS_FILE = "user://options.json"

const DEFAULT_CHECKBOX_VALUE = true
const DEFAULT_SLIDER_VALUE = 0.5

onready var options_menu = load("res://scene/OptionsMenu.tscn").instance()


# Contains the 'current options' that can be checked in real-time from the game if needed
# Populated via init_current_options() 
var current_options = {
#	"checkbox": {
#		"music_checkbox": <some_value>
#	},
#	"slider": {
#		"music_slider": <some_value>
#	},
}


func _ready():
	init_current_options()
	load_options()
	options_take_effect()


func init_current_options():
	if current_options.size() == 0:
		options_menu.init_option_items()
		for i in options_menu.option_items:
			current_options[i] = {}
			for j in options_menu.option_items[i]:
				current_options[i][j] = options_menu.options[i]["default"]


# Actually grant the desired effects (changing audio bus volume etc)
# Some options (eg. auto_switch_weapons) are 'checked' in real-time when needed
# and thus don't need to be added to this function
func options_take_effect():
	for i in current_options:
		for j in current_options[i]:
			match j:
				"music_checkbox":
					var audio_bus = AudioServer.get_bus_index("Music")
					AudioServer.set_bus_mute(audio_bus, not current_options[i][j])
				"sfx_checkbox":
					var audio_bus = AudioServer.get_bus_index("SFX")
					AudioServer.set_bus_mute(audio_bus, not current_options[i][j])
				"ambience_checkbox":
					var audio_bus = AudioServer.get_bus_index("Ambience")
					AudioServer.set_bus_mute(audio_bus, not current_options[i][j])

				"music_slider":
					var audio_bus = AudioServer.get_bus_index("Music")
					AudioServer.set_bus_volume_db(audio_bus, linear2db(current_options[i][j]))
				"sfx_slider":
					var audio_bus = AudioServer.get_bus_index("SFX")
					AudioServer.set_bus_volume_db(audio_bus, linear2db(current_options[i][j]))
				"ambience_slider":
					var audio_bus = AudioServer.get_bus_index("Ambience")
					AudioServer.set_bus_volume_db(audio_bus, linear2db(current_options[i][j]))


# Overwrite OPTIONS_FILE with the current_options dictionary
func save_options():
	var _file = File.new()
	_file.open(OPTIONS_FILE, File.WRITE)
	_file.store_string(to_json(current_options))
	_file.close()
	options_take_effect()


# Overwrite the current_options dictionary with the OPTIONS_FILE json data.
# If OPTIONS_FILE doesn't exist, create it using default data from current_options
func load_options():
	var file = File.new()
	if file.file_exists(OPTIONS_FILE):
		print("Loading existing save file...")
		file.open(OPTIONS_FILE, File.READ)
		_update_load_file(parse_json(file.get_as_text()))
	else:
		print("Creating new save file with default options...")
	file.close()
	save_options()

func _update_load_file(loaded_options):
	for i in current_options:
		# If loaded_options doesn't contain a key, add it and its contents
		if not loaded_options.has(i):
			loaded_options[i] = current_options[i]
			print("Old load file detected! Missing key: '" + str(i) + "'. Updating it now with default value...")
			for j in current_options[i]:
				loaded_options[i][j] = current_options[i][j]
		else:
		# Overwrite current_options with loaded_options if there are changes
			for j in current_options[i]:
				if loaded_options[i][j] != current_options[i][j]:
					current_options[i][j] = loaded_options[i][j]


