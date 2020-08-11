extends Camera2D

const ZOOM_SENSITIVITY = 0.25
const MAX_ZOOM_IN = 0.25
const MAX_ZOOM_OUT = 2.0
const MOVE_SPEED = 600

var input_direction = Vector2.ZERO

signal scroll_from_max # Trigger map view.

func _process(delta):
	if Input.is_action_just_released("zoom_in"):
		do_zoom(true)
	if Input.is_action_just_released("zoom_out"):
		do_zoom(false)
	# Handle movement.
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	position += input_direction * MOVE_SPEED * delta


func do_zoom(zoom_in):
	if zoom_in:
		zoom.x -= ZOOM_SENSITIVITY
		zoom.y -= ZOOM_SENSITIVITY
	else:
		zoom.x += ZOOM_SENSITIVITY
		zoom.y += ZOOM_SENSITIVITY
	if zoom.x > MAX_ZOOM_OUT:
		emit_signal("scroll_from_max")
		zoom.x = MAX_ZOOM_OUT
		zoom.y = MAX_ZOOM_OUT
	elif zoom.x < MAX_ZOOM_IN:
		zoom.x = MAX_ZOOM_IN
		zoom.y = MAX_ZOOM_IN
