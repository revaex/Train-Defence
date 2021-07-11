extends Node


export (bool) var play_audio = false

onready var sounds : Dictionary = {
	"Pistol": $SFX/Gunshot,
	"MachineGun": $SFX/Gunshot,
	"RocketLauncher": $SFX/Rocket,
	"Train": $Ambient/TrainMovement,
	"Explosion": $SFX/Explosion,
}

func play(sound):
	if play_audio:
		sound.play()

func stop(sound):
	sound.stop()

func stop_all():
	for i in sounds:
		sounds[i].stop()
