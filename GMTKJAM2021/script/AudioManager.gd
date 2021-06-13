extends Node



func _ready():
	pass


func playGunshot(current_weapon):
	match current_weapon:
		"Pistol":
			$SFX/Gunshot.play()
		"MachineGun":
			$SFX/Gunshot.play()
		"RocketLauncher":
			$SFX/Rocket.play()
	
	return

func playTrainMovement():
	$Ambient/TrainMovement.play()
	return

func playExplosion():
	$SFX/Explosion.play()
	return
