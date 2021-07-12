extends Panel

signal options_menu_opened()

var currently_open = false
var options_menu_open = false
var exiting = false

func _input(event):
	if not options_menu_open and not exiting:
		if event is InputEventKey:
			if Input.is_action_pressed("Menu"):
				handle_pause()


func handle_pause():
	currently_open = not currently_open
	set_visible(currently_open)
	if currently_open:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_Resume_pressed():
	exiting = false
	handle_pause()


func _on_MainMenu_pressed():
	handle_pause()
	exiting = true
	GlobalSceneChange.goto_scene(GlobalSceneChange.scenes.MainMenu)


func _on_ExitGame_pressed():
	get_tree().quit()


func _on_Options_pressed():
	emit_signal("options_menu_opened")
	options_menu_open = true
