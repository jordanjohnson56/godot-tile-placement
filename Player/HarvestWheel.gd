extends AnimatedSprite

var duration = 2 setget set_duration

func _ready():
	play()


func set_duration(new_duration):
	duration = new_duration
	frames.set_animation_speed("Harvest", 8 / duration)
