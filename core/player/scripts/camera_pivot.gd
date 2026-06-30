extends Node3D

@onready var Player: TurftlePlayer = $".."

@export_group("Camera Movement")
@export var movement_step: float = 1.0
@export var movement_speed: float = 10.0

@export_group("Camera Movement limits")
@export var min_limit: Vector2 = Vector2(-50.0, -50.0)
@export var max_limit: Vector2 = Vector2(50.0, 50.0)

var is_dragging: bool = false
var initial_position: Vector3 = Vector3.ZERO
var target_position: Vector3 = Vector3.ZERO

func _ready() -> void:
	initial_position = global_position
	target_position = global_position

func _process(_delta):
	pass
	
func _physics_process(delta: float) -> void:
	if is_dragging:
		global_position = global_position.lerp(target_position, movement_speed * delta)
	else:
		global_position = global_position.lerp(initial_position, movement_speed * 2 * delta)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.is_pressed()
			target_position = global_position
			
	if event is InputEventMouseMotion and is_dragging:
		var movement = Vector3(-event.relative.x, 0, -event.relative.y)
		
		target_position += movement * movement_step
		
		target_position.x = clamp(target_position.x, min_limit.x, max_limit.x)
		target_position.z = clamp(target_position.z, min_limit.y, max_limit.y)
