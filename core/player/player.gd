extends CharacterBody3D
class_name TurftlePlayer

@export var camera: Camera3D

var zoom_direction: int = 0

func _ready() -> void:
	pass
	
func _process(_delta) -> void:
	if(Input.is_action_just_pressed("ZoomUp")):
		zoom_direction = -1;
	elif(Input.is_action_just_pressed("ZoomDown")):
		zoom_direction = 1;
	else:
		zoom_direction = 0;
	
	#print(zoom_direction)

func get_mouse_world_position() -> Vector3:
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	
	var ground_plane = Plane(Vector3.UP, 0.0)
	
	var intersection = ground_plane.intersects_ray(ray_origin, ray_direction)
	
	if intersection != null:
		return intersection
		
	return Vector3.ZERO
