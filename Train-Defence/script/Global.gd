extends Node

var audio

#var particles : Dictionary # Stores {ParticleName : FilePath.tscn}

#func _ready():
#
#	# Prepare the particle dictionary (can be moved to GlobalParticles later)
#	var particle_files = files_from_dir("res://scene/particles/")
#	for i in particle_files:
#		if i.find(".tscn") != -1: # We only want scene files
#			var slash = i.rfind("/") 
#			var name = i.right(slash + 1) # Take everything from the right of "/" (not inclusive)
#			var tscn = name.rfind(".tscn")
#			name = name.left(tscn) # Take everything from the left of ".tscn"
#			particles[name] = load(i)

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
