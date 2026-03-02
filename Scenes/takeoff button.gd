extends Button

var isActive: bool = false

func _ready() -> void:
	text = "Takeoff / Land button"

func _on_pressed() -> void:
	isActive = !isActive
	if isActive:
		text = "Land"
	else: text = "Takeoff"

func getButtonState() -> bool:
	return isActive
