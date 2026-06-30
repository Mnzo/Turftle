@tool
extends Area3D

@export var grid_area_size: Vector3 = Vector3(1.0, 1.0, 1.0):
	set(value):
		grid_area_size = value
		update_editor_box_shape()

@export var columns_number: int = 5
@export var rows_number: int = 5
@export var tile: PackedScene

@onready var grid_area: Area3D = $"."
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var grid_map: Dictionary = {}

func _ready() -> void:
	if not Engine.is_editor_hint():
		create_tiles()
	
func create_tiles() -> void:
	var box_shape: BoxShape3D = collision_shape.shape as BoxShape3D
	if not box_shape:
		return
		
	var width_x: float = box_shape.size.x
	var depth_z: float = box_shape.size.z
	var center: Vector3 = grid_area.global_position
	
	var desired_size_x: float = width_x / float(columns_number)
	var desired_size_z: float = depth_z / float(rows_number)
	var square_tile_size: float = min(desired_size_x, desired_size_z)
	
	var total_grid_width: float = float(columns_number) * square_tile_size
	var total_grid_depth: float = float(rows_number) * square_tile_size
	
	var offset_x: float = (width_x - total_grid_width) / 2.0
	var offset_z: float = (depth_z - total_grid_depth) / 2.0
	
	var extents: Vector3 = box_shape.size / 2.0
	var start_corner_x: float = center.x - extents.x
	var start_corner_z: float = center.z - extents.z
	
	grid_map.clear()
	
	for r in range(rows_number):
		for c in range(columns_number):
		
			var local_x: float = (start_corner_x + offset_x) + (c * square_tile_size) + (square_tile_size / 2.0)
			var local_z: float = (start_corner_z + offset_z) + (r * square_tile_size) + (square_tile_size / 2.0)
			
			var spawn_location := Vector3(local_x, center.y, local_z)
			
			if tile == null:
				continue
			else:
				var tile_instance: Node3D = tile.instantiate()
				add_child(tile_instance)
				
				tile_instance.global_position = spawn_location
				
				if tile_instance.has_method("setup_tile_data"):
					tile_instance.call("setup_tile_data", square_tile_size, square_tile_size, r, c)
					
				grid_map[Vector2i(r, c)] = tile_instance

func update_editor_box_shape() -> void:
	var shape_node = get_node_or_null("CollisionShape3D")
	if shape_node and shape_node.shape is BoxShape3D:
		shape_node.shape.size = grid_area_size
