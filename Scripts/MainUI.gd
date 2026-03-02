extends Control

@onready var left_joy = $LeftJoystick
@onready var right_joy = $RightJoystick
@onready var takeoff_button: Button = $"Buttons/Takeoff button"
@onready var stop_motors_button: Button = $"Buttons/StopMotors button"
@onready var motor_values_text: Label = $"Labels/MotorValues text"

var udp = PacketPeerUDP.new()
var motors = [0, 0, 0, 0]
var previousValue = [0, 0, 0, 0]
var is_first_run = true

func _ready() -> void:
	udp.connect_to_host("192.168.4.1", 5050)

func _process(_delta: float) -> void:
	# 1. Get Inputs
	var move = left_joy.get_value()
	var alt = right_joy.get_value()
	
	var roll = move.x
	var pitch = -move.y
	var yaw = alt.x
	var thrust = ((-alt.y) + 1.0) / 2.0 

	# 2. Check Activation
	var takeOff: bool = takeoff_button.getButtonState()
	var motorsActive: bool = stop_motors_button.getButtonState()
	if not motorsActive:
		if takeOff:
			var frontLeft = thrust + pitch + roll + yaw
			var frontRight = thrust + pitch - roll - yaw
			var backLeft = thrust - pitch + roll - yaw
			var backRight = thrust - pitch - roll + yaw

			motors = [frontLeft, frontRight, backLeft, backRight]
			
			for i in range(4):
				motors[i] = clampi(int(motors[i] * 255), 40, 255)
		else:
			motors = [80, 80, 80, 80]
	else: motors = [0,0,0,0]

	# 3. Only send if changed AND it's not the first frame
	if motors != previousValue:
		if is_first_run:
			is_first_run = false
		else:
			send_motor_speeds(motors)

	previousValue = motors.duplicate()

#region functions
func send_motor_speeds(motor_values: Array) -> void:
	var data = PackedByteArray()
	var strOut = "Motor values = "
	for value in motor_values:
		data.append(value)
		strOut += str(value) + ", "
	if udp.get_packet_error() == OK:
		udp.put_packet(data)
		
		motor_values_text.text = strOut
#endregion
