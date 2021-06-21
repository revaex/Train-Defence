extends Node2D


onready var base_item = Item.new()
onready var train = get_tree().current_scene.get_node("Train")
var spawned_items = []

var game_over = false

func _ready():
	randomize()
	
# warning-ignore:return_value_discarded
	$Character.connect("blink", self, "tele_to_carriage")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("game_over", self, "_on_game_over")
	
	Global.audio.playTrainMovement()
	
	$ItemSpawner.spawn(4, base_item.ItemType.GUN)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	$Crosshair.position = get_global_mouse_position()
	
func tele_to_carriage(carriage_num):
	for i in train.get_children():
		if i.is_in_group("carriages"):
			if carriage_num == i.name.rsplit("Carriage", false)[0] as int:
				$Character.successful_blink(i.global_position, carriage_num)


func _on_game_over():
	if not game_over:
		game_over = true
		GlobalSceneChange.goto_scene("res://scene/MainMenu.tscn")

