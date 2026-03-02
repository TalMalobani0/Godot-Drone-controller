extends Node2D

@onready var joystick_knob: Sprite2D = $Joystick_Knob
var max_range = 100.0  # How far the joystick_knob can move from center
var touch_index = -1   # -1 means not being touched/clicked
var output = Vector2.ZERO

func _input(event):
	# Handle Mouse Click or Touch
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			# If click is inside the joystick base
			if event.position.distance_to(global_position) < max_range:
				touch_index = 0 # Activate
		else:
			# If button released, reset
			touch_index = -1
			_reset_joystick()

	# Handle Dragging
	if (event is InputEventMouseMotion or event is InputEventScreenDrag) and touch_index != -1:
		var center = global_position
		var vector = event.position - center
		
		if name == "RightJoystick":
			if abs(vector.x) > abs(vector.y):
				vector.y = 0 # Lock vertical
			else:
				vector.x = 0 # Lock horizontal
		
		# Clamp the joystick_knob inside the circle
		if vector.length() > max_range:
			vector = vector.normalized() * max_range
		
		joystick_knob.position = vector
		output = vector / max_range # Returns -1.0 to 1.0

func _reset_joystick():
	joystick_knob.position = Vector2.ZERO
	output = Vector2.ZERO

func get_value():
	return output
