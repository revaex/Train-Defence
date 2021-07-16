extends Panel


var gun
onready var outline = $ReferenceRect


func _ready():
	$Control/TextureRect.texture = gun.get_node("Sprite").texture
	$Control/TextureRect.rect_rotation = 90


func setup(_gun):
	gun = _gun

