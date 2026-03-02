extends Button

var isActive: bool = false

func _ready() -> void:
	text = "Shut motors down"

func _on_pressed() -> void:
	isActive = !isActive
	if isActive:
		text = "Turn on motors"
	else: text = "shut motors down"
	
func getButtonState() -> bool:
	return isActive
