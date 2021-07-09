extends Node2D


onready var base_item = $ItemSpawner.base_item
onready var item_spawner = $ItemSpawner # Used by other scripts to avoid get_node

var game_over = false # To ensure the game over scene change only happens once

func _ready():
# warning-ignore:return_value_discarded
	GlobalEvents.connect("game_over", self, "_on_game_over")
	
	$ItemSpawner.spawn(5, base_item.ItemType.GUN, 2)
	$ItemSpawner.spawn(3, base_item.ItemType.HEALTH, 3)


func _on_game_over():
	if not game_over:
		game_over = true
		GlobalSceneChange.goto_scene(GlobalSceneChange.scenes.MainMenu)
