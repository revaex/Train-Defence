extends Panel

onready var character = get_tree().current_scene.get_node("Character")

# The following exported values are set in the inspector and autmatically 
# update if the nodes are re-arranged in the scene
export (NodePath) onready var hp_bar = get_node(hp_bar)
export (NodePath) onready var hp_bar_tween = get_node(hp_bar_tween)
export (NodePath) onready var hp_label = get_node(hp_label)
export (NodePath) onready var ammo_bar = get_node(ammo_bar)
export (NodePath) onready var ammo_bar_tween = get_node(ammo_bar_tween)
export (NodePath) onready var ammo_label = get_node(ammo_label)
export (NodePath) onready var exp_bar = get_node(exp_bar)
export (NodePath) onready var exp_bar_tween = get_node(exp_bar_tween)
export (NodePath) onready var exp_label = get_node(exp_label)


func _ready():
# warning-ignore:return_value_discarded
	GlobalEvents.connect("bar_value_changed", self, "_on_bar_value_changed")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("bar_max_value_changed", self, "_on_bar_max_value_changed")
	
	# The following two global signals can be used if the UI labels need to update
	# without the ProgressBars (the mini-bars attached to the entities) updating,
	# in the case of picking up ammo for example:
	
# warning-ignore:return_value_discarded
	GlobalEvents.connect("update_hp_label", self, "_on_update_hp_label")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("update_ammo_label", self, "_on_update_ammo_label")
# warning-ignore:return_value_discarded
	GlobalEvents.connect("update_exp_label", self, "_on_update_exp_label")
	
	hp_bar.max_value = character.max_hp
	hp_bar.value = character.max_hp
	hp_bar.step = character.get_node("HPBar/Bar").step
	update_label(hp_label)
	
	ammo_bar.max_value = character.get_node("AmmoBar/Bar").max_value
	ammo_bar.value = character.get_node("AmmoBar/Bar").value
	ammo_bar.step = character.get_node("AmmoBar/Bar").step
	update_label(ammo_label)
	
	exp_bar.max_value = character.get_node("ExpBar/Bar").max_value
	exp_bar.value = character.get_node("ExpBar/Bar").value
	exp_bar.step = character.get_node("ExpBar/Bar").step
	update_label(exp_label)

func update_label(label):
	if label == hp_label:
		label.text = str(character.current_hp) + "/" + str(character.max_hp)
	elif label == ammo_label:
		label.text = str(character.clip_size) + "/" + str(character.current_weapon.clip_size) + "/" + str(character.current_weapon.total_ammo)
	elif label == exp_label:
		label.text = str(character.exp_handler.experience) + "/" + str(character.exp_handler.experience_required) + "/" + str(character.level)

func _on_bar_value_changed(value, bar):
	if bar is HPBar:
		hp_bar_tween.interpolate_property(hp_bar, "value", hp_bar.value, value, 0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
		hp_bar_tween.start()
		update_label(hp_label)
	elif bar is AmmoBar:
		ammo_bar_tween.interpolate_property(ammo_bar, "value", ammo_bar.value, value, 0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
		ammo_bar_tween.start()
		update_label(ammo_label)
	elif bar is ExpBar:
		exp_bar_tween.interpolate_property(exp_bar, "value", exp_bar.value, value, 0.25, Tween.TRANS_SINE, Tween.EASE_OUT)
		exp_bar_tween.start()
		update_label(exp_label)

func _on_bar_max_value_changed(value, bar):
	if bar is HPBar:
		hp_bar.max_value = value
		update_label(hp_label)
	elif bar is AmmoBar:
		ammo_bar.max_value = value
		update_label(ammo_label)
	elif bar is ExpBar:
		exp_bar.max_value = value
		update_label(exp_bar)

func _on_update_hp_label():
	update_label(hp_label)

func _on_update_ammo_label():
	update_label(ammo_label)

func _on_update_exp_label():
	update_label(exp_label)
