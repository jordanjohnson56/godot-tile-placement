extends Node2D

export(Texture) var BUILDING1_IMAGE = null
export(String) var BUILDING1_PATH = ""
export(float) var GRID_SIZE = 32.0

var building_select = 0
var digging = false
var digWheel = preload("res://Player/DigWheel.tscn")
var digWheelInstance = null

onready var sprite = $Sprite

func _process(_delta):
	# Texture selection via input from a number key.
	if Input.is_action_just_pressed("building1"):
		building_select = 1
		sprite.texture = BUILDING1_IMAGE
	
	# We'll use the mouse position to determine where the texture should be drawn.
	var mouse_position = get_global_mouse_position()
	position = mouse_position - mouse_position.posmod(GRID_SIZE)
	
	# Check if the building should be placed or if we should start digging.
	if Input.is_action_just_pressed("select"):
		match building_select:
			0:
				start_digging()
			_:
				place_building()
	
	# Check if we should stop digging.
	if digging && Input.is_action_just_released("select"):
		stop_digging()


func place_building():
	var building
	match building_select:
		1:
			building = load(BUILDING1_PATH)
	var inst = building.instance()
	inst.position = position
	get_tree().get_root().add_child(inst)
	building_select = 0
	sprite.texture = null


# This is not the best way to do this. Need to create some instance that can
# take in function calls for this and handle it externally. Basically, we don't
# want the digging action to be linked to the mouse anymore after it starts. The
# mouse should only be responsible for telling it to start and to stop. We could
# do this with a single instance of a dig wheel which is hidden until it starts.
# Then we can pass it the current positon just once, and then call its functions
# to start and stop it. The start function would pass the global position at
# which it should be placed.
func start_digging():
	digging = true
	digWheelInstance = digWheel.instance()
	digWheelInstance.position = position
	get_tree().get_root().add_child(digWheelInstance)
	digWheelInstance.connect("animation_finished", self, "_dig_anim_finished")


func _dig_anim_finished():
	print("Got an ore!")
	start_digging()


func stop_digging():
	digging = false
	digWheelInstance.stop()
	digWheelInstance = null
