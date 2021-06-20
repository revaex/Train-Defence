extends Node

var audio : Node
var train


func files_from_dir(path, filename_only=false):
	var files = []
	var dir = Directory.new()
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if not dir.current_is_dir():
				if filename_only:
					files.append(file)
				else:
					# Make sure directory path ends in slash
					if path[-1] != "/":
						path = path + "/"
					files.append(path + file)
			file = dir.get_next()
		return files
	else:
		print("Can't access filepath: " + path)
