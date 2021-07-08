extends Panel

onready var LPI = preload("res://scene/UI/LootPanelItem.tscn")


export (int) var max_items = 4
var count = 0


func _ready():
# warning-ignore:return_value_discarded
	GlobalEvents.connect("item_picked_up_loot_panel", self, "_on_item_picked_up")


func add_item(item, ammo):
	var LPI_instance = LPI.instance()
	LPI_instance.setup(item, ammo)
	add_child(LPI_instance)
	LPI_instance.rect_position = Vector2(rect_size.x/5,0)
	LPI_instance.connect("loot_panel_item_expired", self, "_on_loot_panel_item_expired")
	count += 1
	
	if get_child_count() > max_items:
		remove_item(get_child(0))
	
	for i in get_children():
		if i.get_position_in_parent() < get_child_count() - 1:
			i.rect_position.y += 32
	var item_tween = LPI_instance.get_node("Tween")
	item_tween.interpolate_property(LPI_instance, "rect_position:x", LPI_instance.rect_position.x, 0, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	item_tween.start()


func remove_item(loot_panel_item):
	remove_child(loot_panel_item)
	loot_panel_item.disconnect("loot_panel_item_expired", self, "_on_loot_panel_item_expired")

func _on_item_picked_up(item, ammo):
	add_item(item, ammo)

func _on_loot_panel_item_expired(loot_panel_item):
	remove_item(loot_panel_item)


