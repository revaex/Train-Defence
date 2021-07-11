extends MarginContainer

var options_menu_scene = "res://scene/OptionsMenu.tscn"

var vp_container
var vp
var options_menu


func _ready():
# warning-ignore:return_value_discarded
	owner.get_node("MenuPanel").connect("options_menu_opened", self, "_on_options_menu_opened")


func _on_options_menu_opened():
	_init_options_viewport()


func _init_options_viewport():
	vp_container = ViewportContainer.new()
	vp = Viewport.new()
	options_menu = load(options_menu_scene).instance()
	
	owner.add_child(vp_container)
	vp_container.add_child(vp)
	vp.add_child(options_menu)
	vp_container.stretch = true
	vp_container.rect_size = get_viewport().size - Vector2(get_constant("margin_right")*2, get_constant("margin_bottom")*2)
	vp_container.rect_position += Vector2(get_constant("margin_right"), get_constant("margin_bottom"))
	options_menu.connect("options_menu_closed", self, "_on_options_menu_closed")


func _on_options_menu_closed():
	owner.get_node("MenuPanel").options_menu_open = false
	options_menu.queue_free()
	vp.queue_free()
	vp_container.queue_free()
