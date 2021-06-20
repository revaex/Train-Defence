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

func playTrainMovement():
	$Ambient/TrainMovement.play()

func playExplosion():
	$SFX/Explosion.play()
