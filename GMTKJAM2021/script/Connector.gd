extends Area2D



export var hp : int

var scaled_hp = 100.0


func damage(dmg : int):
	var scaled_damage = (float(dmg) / float(hp) * 100.0)
	print(scaled_damage)
	scaled_hp -= scaled_damage
	$HPBar.visible = true
	$HPBar.value = scaled_hp
	if scaled_hp <= 0:
		break_connector()
	return
	
func break_connector():
	print("Connector Broke!")
	queue_free()
	return
