extends Node2D

onready var local_position_in_parent = position

func _ready():
	#get_parent().connect("damage_taken", self, "_on_parent_damage_taken")
	self.set_visible(false)

func _process(_delta):
	self.set_global_rotation(0)
	self.set_global_position(get_parent().global_position + local_position_in_parent)

#func _on_parent_damage_taken(damage):
#	pass
