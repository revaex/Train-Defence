extends Control


onready var character = get_tree().current_scene.get_node("Character")

onready var hp_bar = $Panel/MarginContainer/VB/HBHealth/HealthBar
onready var hp_bar_tween = $Panel/MarginContainer/VB/HBHealth/HealthBar/Tween
onready var hp_label = $Panel/MarginContainer/VB/HBHealth/HealthValue
onready var ammo_bar = $Panel/MarginContainer/VB/HBAmmo/AmmoBar
onready var ammo_bar_tween = $Panel/MarginContainer/VB/HBAmmo/AmmoBar/Tween
onready var ammo_label = $Panel/MarginContainer/VB/HBAmmo/AmmoValue


func _ready():
# warning-ignore:return_value_discarded
	GlobalEvents.connect("bar_value_changed", self, "_on_bar_value_changed")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("bar_max_value_changed", self, "_on_bar_max_value_changed")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("update_hp_label", self, "_on_update_hp_label")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("update_ammo_label", self, "_on_update_ammo_label")
	
	hp_bar.max_value = character.max_hp
	hp_bar.value = character.max_hp
	hp_bar.step = character.get_node("HPBar/Bar").step
	update_label(hp_label)
	
	ammo_bar.max_value = character.get_node("AmmoBar/Bar").max_value
	ammo_bar.value = character.get_node("AmmoBar/Bar").value
	ammo_bar.step = character.get_node("AmmoBar/Bar").step
	update_label(ammo_label)

func update_label(label):
	if label == hp_label:
		label.text = str(character.current_hp) + "/" + str(character.max_hp)
	if label == ammo_label:
		label.text = str(character.clip_size) + "/" + str(character.current_weapon.clip_size) + "/" + str(character.current_weapon.total_ammo)


func _on_bar_value_changed(value, bar):
	if bar is HPBar:
		hp_bar_tween.interpolate_property(hp_bar, "value", hp_bar.value, value, 0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
		hp_bar_tween.start()
		update_label(hp_label)
	elif bar is AmmoBar:
		ammo_bar_tween.interpolate_property(ammo_bar, "value", ammo_bar.value, value, 0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
		ammo_bar_tween.start()
		update_label(ammo_label)

func _on_bar_max_value_changed(value, bar):
	if bar is HPBar:
		hp_bar.max_value = value
		update_label(hp_label)
	if bar is AmmoBar:
		ammo_bar.max_value = value
		update_label(ammo_label)

func _on_update_hp_label():
	update_label(hp_label)

func _on_update_ammo_label():
	update_label(ammo_label)
