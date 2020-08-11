extends TileMap

const CHUNK_SIZE = 64

const HARVEST_WHEEL = preload("res://Player/HarvestWheel.tscn")
var harvest_wheel = null
var harvest_target = -1
var start_time = 0


func _ready():
	generate_chunk()


func generate_chunk():
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			set_cell(x, y, 0)


func _unhandled_input(event):
	if event.get_class() == "InputEventMouseButton":
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				# Click started.
				click_started()
			else:
				# Click ended.
				click_ended()
			get_tree().set_input_as_handled()


func click_started():
	# Get the tile that was clicked.
	var mouse_position = get_global_mouse_position()
	var cell_position = (mouse_position / cell_size).floor()
	var cell_type = get_cellv(cell_position)
	if cell_type > 0:
		# Ore
		create_harvest_wheel(cell_position*cell_size)
		harvest_target = cell_type


func click_ended():
	if harvest_wheel != null:
		harvest_wheel.queue_free()
		harvest_wheel = null
	harvest_target = -1


func create_harvest_wheel(place_position):
	# Create a wheel that indicates an ore is being harvested.
	harvest_wheel = HARVEST_WHEEL.instance()
	harvest_wheel.position = place_position
	harvest_wheel.duration = 0.8
	harvest_wheel.connect("animation_finished", self, "_harvest_wheel_finished")
	add_child(harvest_wheel)
	start_time = OS.get_ticks_msec()


func _harvest_wheel_finished():
	var end_time = OS.get_ticks_msec()
	print("Finished! Got Ore ", harvest_target, " in ", (end_time - start_time)/1000.0, " seconds!")
	start_time = end_time
