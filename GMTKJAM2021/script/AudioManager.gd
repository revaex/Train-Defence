extends Node



func _ready():
	pass


func playGunshot():
	$SFX/Gunshot.play()
	return

func playTrainMovement():
	$Ambient/TrainMovement.play()
	return
