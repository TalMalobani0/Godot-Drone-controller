extends Control

@onready var left_joy = $LeftJoystick
@onready var right_joy = $RightJoystick
@onready var takeoff_button: Button = $"Buttons/Takeoff button"
@onready var stop_motors_button: Button = $"Buttons/StopMotors button"
@onready var motor_values_text: Label = $"Labels/MotorValues text"

var udp = PacketPeerUDP.new()
var previous_data = []
var is_first_run = true

func _ready() -> void:
	udp.connect_to_host("192.168.4.1", 5050)

func _process(_delta: float) -> void:
	var leftJoyStick = left_joy.get_value()
	var rightJoyStick = right_joy.get_value()
	
	# Mapping joystick (-1.0 to 1.0) to byte (0 to 255)
	var alt_y   = clampf(-rightJoyStick.y, -1.0, 1.0)
	var move_x  = clampf(leftJoyStick.x, -1.0, 1.0)
	var move_y  = clampf(-leftJoyStick.y, -1.0, 1.0)
	var alt_x   = clampf(rightJoyStick.x, -1.0, 1.0) 
	
	var throttle = roundi(remap(alt_y, -1.0, 1.0, 0, 255))
	var roll     = roundi(remap(move_x, -1.0, 1.0, 0, 255))
	var pitch    = roundi(remap(move_y, -1.0, 1.0, 0, 255))
	var yaw      = roundi(remap(alt_x, -1.0, 1.0, 0, 255))

	# 2. Check Activation States
	var current_send_data = [0, 128, 128, 128]
	
	var is_stopped = stop_motors_button.getButtonState()
	var is_taking_off = takeoff_button.getButtonState()

	if not is_stopped:
		if is_taking_off:
			current_send_data = [throttle, pitch, roll, yaw]
		else:
			current_send_data = [40, 128, 128, 128]

	# only send if data changed
	if current_send_data != previous_data:
		if is_first_run:
			is_first_run = false
		else:
			send_to_drone(current_send_data)
		previous_data = current_send_data

func send_to_drone(data_array: Array) -> void:
	var packet = PackedByteArray(data_array)
	
	if udp.get_packet_error() == OK:
		udp.put_packet(packet)
		motor_values_text.text = "T:%d P:%d R:%d Y:%d" % [data_array[0], data_array[1], data_array[2], data_array[3]]
