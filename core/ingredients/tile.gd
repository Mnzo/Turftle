@tool
extends Node3D

@onready var visual: MeshInstance3D = $Visual

var tile_row_id: int = 0
var tile_column_id: int = 0

func setup_tile_data(size_x: float, size_z: float, row_id: int, column_id: int) -> void:
	tile_row_id = row_id
	tile_column_id = column_id
	
	if visual and visual.mesh is QuadMesh:
		visual.mesh = visual.mesh.duplicate()
		visual.mesh.size = Vector2(size_x, size_z)
		
		var mat = visual.get_material_override()
		if mat:
			var unique_mat = mat.duplicate()
			visual.set_material_override(unique_mat)
			
func set_tile_visuals(color: Color, emissive_strength: float) -> void:
	var mat = visual.get_material_override() as ShaderMaterial
	if mat:
		mat.set_shader_parameter("Color", color)
		mat.set_shader_parameter("EmissiveStrength", emissive_strength)
