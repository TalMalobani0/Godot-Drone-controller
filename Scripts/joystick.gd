extends Node2D

@onready var joystick_knob: Sprite2D = $Joystick_Knob
var max_range = 100.0  # How far the joystick_knob can move from center
var touch_index = -1
var output = Vector2.ZERO

func _input(event):
	var current_index = 0
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		current_index = event.index

	# 2. Handle Press
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			if touch_index == -1 and event.position.distance_to(global_position) < max_range:
				touch_index = current_index
		else:
			if current_index == touch_index:
				touch_index = -1
				reset_joystick()

	# 3. Handle Dragging
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if current_index == touch_index:
			var vector = event.position - global_position
			
			if name == "RightJoystick":
				if abs(vector.x) > abs(vector.y):
					vector.y = 0
				else:
					vector.x = 0
			
			# Clamp the joystick_knob inside the circle
			if vector.length() > max_range:
				vector = vector.normalized() * max_range
			
			joystick_knob.position = vector
			output = vector / max_range # Returns -1.0 to 1.0

func reset_joystick():
	joystick_knob.position = Vector2.ZERO
	output = Vector2.ZERO

func get_value():
	return output
