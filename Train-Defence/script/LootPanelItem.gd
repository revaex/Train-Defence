extends HBoxContainer

signal loot_panel_item_expired(loot_panel_item)

export (float) var expiry_time = 4.0
var item
var ammo

func setup(_item : Item, _ammo):
	item = _item
	ammo = _ammo

func _ready():
	$TextureRect.texture = item.get_node("Sprite").texture
	$TextureRect.self_modulate = item.get_node("Sprite").self_modulate
	$Label.text = item.display_name
	if ammo:
		$Label.text += " (" + str(ammo) + " ammo)"
	$Timer.wait_time = expiry_time
	$Timer.start()

func _on_Timer_timeout():
	emit_signal("loot_panel_item_expired", self)
