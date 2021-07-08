extends Node


export (bool) var play_audio = false

onready var Sounds : Dictionary = {
	"Guns": {
		"Pistol": $SFX/Gunshot,
		"MachineGun": $SFX/Gunshot,
		"RocketLauncher": $SFX/Rocket,
	},
	"Train": $Ambient/TrainMovement,
	"Explosion": $SFX/Explosion,
}

func play(sound):
	if play_audio:
		sound.play()
