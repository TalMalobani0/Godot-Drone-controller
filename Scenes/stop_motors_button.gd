extends Button

var isActive: bool = false

func _ready() -> void:
	text = "Shut motors down"

func _on_pressed() -> void:
	isActive = !isActive
	
func GetButtonState() -> bool:
	return isActive
