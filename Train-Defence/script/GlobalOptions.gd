extends Node


const OPTIONS_FILE = "user://options.json"

const DEFAULT_CHECKBOX_VALUE = true
const DEFAULT_SLIDER_VALUE = 0.5

onready var options_menu = load("res://scene/OptionsMenu.tscn").instance()


# current_options is populated via init_current_options() 
var current_options = {
	"checkbox": {},
	"slider": {},
}


func _ready():
	init_current_options()
	load_options()
	options_take_effect()


# Actually grant the desired effects (changing audio bus volume etc)
# Some options (eg. auto_switch_weapons) are 'checked' in real-time when needed
# and thus don't need to be added to this function
func options_take_effect():
	for i in current_options:
		match i:
			"checkbox":
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
			"slider":
				for j in current_options[i]:
					match j:
						"music_slider":
							var audio_bus = AudioServer.get_bus_index("Music")
							AudioServer.set_bus_volume_db(audio_bus, linear2db(current_options[i][j]))
						"sfx_slider":
							var audio_bus = AudioServer.get_bus_index("SFX")
							AudioServer.set_bus_volume_db(audio_bus, linear2db(current_options[i][j]))
						"ambience_slider":
							var audio_bus = AudioServer.get_bus_index("Ambience")
							AudioServer.set_bus_volume_db(audio_bus, linear2db(current_options[i][j]))

func init_current_options():
	if current_options["checkbox"].size() == 0 and current_options["slider"].size() == 0:
		options_menu.init_option_items()
		var options = options_menu.option_items
		for i in options:
			match i:
				"checkbox":
					for j in options[i]:
						current_options[i][j] = DEFAULT_CHECKBOX_VALUE
				"slider":
					for j in options[i]:
						current_options[i][j] = DEFAULT_SLIDER_VALUE


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
		
		for i in loaded_options:
			# Ensure loaded_options dictionary matches current_options dictionary
			if loaded_options[i].size() != current_options[i].size():
				print("Disrepency between loaded data and internal options.")
				print("Re-creating save file with defaults...")
				file.close()
				save_options()
				return
			
			# Overwrite current_options with loaded_options if there are changes
			for j in loaded_options[i]:
				if loaded_options[i][j] != current_options[i][j]:
					current_options[i][j] = loaded_options[i][j]
	else:
		print("Creating new save file with default options...")
		save_options()
	file.close()
