extends CharacterBody3D
class_name TurftlePlayer

var zoom_direction: int = 0

func _ready() -> void:
	pass
	
func _process(delta) -> void:
	if(Input.is_action_just_pressed("ZoomUp")):
		zoom_direction = -1;
	elif(Input.is_action_just_pressed("ZoomDown")):
		zoom_direction = 1;
	else:
		zoom_direction = 0;
	
	print(zoom_direction)
