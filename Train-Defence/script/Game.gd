extends Node2D


onready var base_item = $ItemSpawner.base_item
onready var item_spawner = $ItemSpawner

var game_over = false

func _ready():
# warning-ignore:return_value_discarded
	GlobalEvents.connect("game_over", self, "_on_game_over")
	
	$ItemSpawner.spawn(5, base_item.ItemType.GUN, 2)
	$ItemSpawner.spawn(3, base_item.ItemType.HEALTH, 3)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	$Crosshair.position = get_global_mouse_position()


func _on_game_over():
	if not game_over:
		game_over = true
		GlobalSceneChange.goto_scene("res://scene/MainMenu.tscn")

