extends Node2D

@onready var joystick_knob: Sprite2D = $Joystick_Knob
var max_range = 100.0  # How far the joystick_knob can move from center
var touch_index = -1
var output = Vector2.ZERO

var idx = 0
func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event is InputEventScreenTouch:
			var idx = event.index
		else: 
			var idx = 0
		if event.pressed:
			if touch_index == -1 and event.position.distance_to(global_position) < max_range:
				touch_index = idx
		elif idx == touch_index:
			touch_index = -1
			reset_joystick()

	# Handle Dragging
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if event is InputEventScreenDrag:
			idx = event.index
		else: idx = 0
		if idx == touch_index:
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
