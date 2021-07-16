extends Panel

export (NodePath) onready var HB = get_node(HB)

var WPI = preload("res://scene/UI/WeaponPanelItem.tscn")

onready var character = get_tree().current_scene.get_node("Character")

var weapons = []

export (float) var fade_time = 0.35
export (float) var alive_time = 3.0

# current_selection is type 'WPI', however the setter function takes a 'weapon'
# for convenience, then converts it into the corresponding WPI
var current_selection = null setget _set_current_selection


func _ready():
# warning-ignore:return_value_discarded
	GlobalEvents.connect("new_weapon_picked_up", self, "_on_new_weapon_picked_up")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("changed_weapons", self, "_on_changed_weapons")
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	setup()
	$VisibilityTimer.wait_time = alive_time


func setup():
	for i in character.get_node("WeaponHandler").get_children():
		_add_new_WPI(i)
	_set_current_selection(character.get_node("WeaponHandler").get_child(0))


func _display_weapon_panel():
	$VisibilityTimer.start()
	$Tween.interpolate_property(self, "modulate", modulate, Color.white, fade_time,Tween.TRANS_SINE)
	$Tween.start()

func _hide_weapon_panel():
	$Tween.interpolate_property(self, "modulate", modulate, Color(1.0, 1.0, 1.0, 0.0), fade_time,Tween.TRANS_SINE)
	$Tween.start()


func _add_new_WPI(weapon):
	var new_WPI = WPI.instance()
	new_WPI.setup(weapon)
	HB.add_child(new_WPI)
	weapons.append(new_WPI)


func _on_new_weapon_picked_up(weapon):
	_add_new_WPI(weapon)
	if GlobalOptions.current_options["checkbox"]["auto_switch_weapons_checkbox"]:
		_display_weapon_panel()
		_set_current_selection(weapon)


func _on_changed_weapons(weapon):
	_display_weapon_panel()
	_set_current_selection(weapon)


func _on_VisibilityTimer_timeout():
	_hide_weapon_panel()


func _set_current_selection(weapon):
	var _WPI = weapons[weapon.get_position_in_parent()]
	if current_selection:
		current_selection.outline.hide()
	current_selection = _WPI
	_WPI.outline.show()

