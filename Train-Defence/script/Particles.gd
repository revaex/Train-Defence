extends CPUParticles2D


signal finished_emitting(particle)

func _ready():
	set_process(false)

func _process(_delta):
	if not emitting:
		emit_signal("finished_emitting", self)
		set_process(false)

func activate():
	emitting = false
	emitting = true
	set_process(true)
