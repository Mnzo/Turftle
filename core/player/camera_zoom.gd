extends Node3D

@onready var Player: TurftlePlayer = $"../.."

@export_group("Camera Zoom")
@export var zoom_step: float = 0.2
@export var zoom_speed: float = 2.0
@export_group("Default Zoom values")
@export var default_zoom_alpha: float = 0.5
@export_group("Min Zoom values")
@export var min_zoom_y: float = 9.0
@export var min_zoom_z: float = 0.0
@export var min_zoom_rotx: float = -90
var min_zoom_rotx_rad: float 
@export_group("Max Zoom values")
@export var max_zoom_y: float = 18.0
@export var max_zoom_z: float = 10.0
@export var max_zoom_rotx: float = -65.0
var max_zoom_rotx_rad: float

var current_zoom_alpha: float = 0.0
var destination_zoom_alpha: float = 0.0

func _ready() -> void:
	current_zoom_alpha = default_zoom_alpha
	destination_zoom_alpha = default_zoom_alpha
	
	min_zoom_rotx_rad = deg_to_rad(min_zoom_rotx)
	max_zoom_rotx_rad = deg_to_rad(max_zoom_rotx)
	
	update_camera()

func _process(delta):
	if(Player.zoom_direction == 1):
		destination_zoom_alpha += zoom_step
	elif(Player.zoom_direction == -1):
		destination_zoom_alpha -= zoom_step
	
	destination_zoom_alpha = clamp(destination_zoom_alpha, 0.0, 1.0)
	
	if(current_zoom_alpha != destination_zoom_alpha):
		current_zoom_alpha = lerp(current_zoom_alpha, destination_zoom_alpha, zoom_speed * delta)
	
	update_camera()

func set_alpha(value: float):
	current_zoom_alpha = value

func update_camera() -> void:
	var new_zoom_y = lerpf(min_zoom_y, max_zoom_y, current_zoom_alpha)
	var new_zoom_z = lerpf(min_zoom_z, max_zoom_z, current_zoom_alpha)
	var new_zoom_rotx = lerpf(min_zoom_rotx_rad, max_zoom_rotx_rad, current_zoom_alpha)
	
	position = Vector3(0.0, new_zoom_y, new_zoom_z)
	rotation = Vector3(new_zoom_rotx, 0.0, 0.0)
	
	#print("Current Alpha " + str(current_zoom_alpha))
	#print("Destination Alpha " + str(current_zoom_alpha))
	#print(position)
	#print(rotation)
