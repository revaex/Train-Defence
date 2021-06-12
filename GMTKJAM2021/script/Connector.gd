extends Area2D



export var hp : int

func damage(dmg : int):
	hp -= dmg
	if hp < 100:
		$HPBar.visible
		$HPBar.value = hp
		
		if hp <= 0:
			break_connector()
	return
	
func break_connector():
	print("Connector Broke!")
	queue_free()
	return
