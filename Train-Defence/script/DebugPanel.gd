extends Panel


var debug_items = []


func _ready():
	if not OS.is_debug_build():
		set_process(false)
		hide()

func add(name, obj, ref, is_method=false):
	debug_items.append([name, obj, ref, is_method])


func _process(_delta):
	var text = ""
	
	for i in debug_items:
		var value = null
		if is_instance_valid(i[1]):
			if i[3]:
				value = i[1].call(i[2])
			else:
				value = i[1].get(i[2])
				
		if i[2] == "get_static_memory_usage":
			text += i[0] + ": " + String.humanize_size(value) + "\n"# "%10.3f" % value + "\n"
			
		elif typeof(value) == TYPE_VECTOR2:
			text += i[0] + ": (" + "%.3f, %.3f)\n" % [value.x, value.y]
			
		else:
			text += i[0] + ": " + str(value) + "\n"
	
	$MarginContainer/Label.text = text
