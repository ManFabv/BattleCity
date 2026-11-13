@tool
class_name SightAttackDetector
extends Node3D

## width of the ring that shows the detection range in the editor
const _RANGE_PREVIEW_WIDTH : float = 0.1

@export_group("References")
## who is the entity we are checking detection for
@export var _owner_controllable_entity : ControllableEntity

@export_group("Attack Detection")
## max distance at which the player or base is considered a valid attack target
@export_range(0.1, 20.0) var _detection_range : float = 12.0:
	set(new_value):
		# we prevent negative ranges
		_detection_range = maxf(new_value, 0.0)
		# the editor ring follows the value set in the Inspector
		_update_range_preview()
## used to sweep for obstacles between the entity and its target
@export var _vision_shape_cast : ShapeCast3D

@export_group("Editor Preview")
## color of the ring that shows the detection range in the editor viewport
@export var _range_preview_color : Color = Color(1.0, 0.25, 0.25, 0.6):
	set(new_value):
		_range_preview_color = new_value
		# the editor ring follows the value set in the Inspector
		_update_range_preview()

## ring drawn around the entity in the editor only, never created in game nor saved in the scene
var _range_preview_mesh_instance : MeshInstance3D


## in the editor we draw the detection range, in game this node only answers sight checks
func _ready() -> void:
	if Engine.is_editor_hint():
		_create_range_preview()


## true if the target is in range and nothing blocks the sweep toward it; the caller validates it
func has_detected_target(target: Node3D) -> bool:
	# we cache the target position
	var target_position : Vector3 = target.global_position
	# as a quick filter, if the target is out of range we exit early
	if not _is_target_in_range(target_position):
		return false
	# the target is detected if nothing blocks the line of sight
	return not _is_shape_cast_colliding(target_position)


## creates the editor ring as an internal child, so it isn't listed in the scene tree nor saved
func _create_range_preview() -> void:
	_range_preview_mesh_instance = MeshInstance3D.new()
	_range_preview_mesh_instance.mesh = TorusMesh.new()
	# unshaded and transparent, so it reads the same under any light and doesn't hide the level
	var material : StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_range_preview_mesh_instance.material_override = material
	add_child(_range_preview_mesh_instance, false, Node.INTERNAL_MODE_BACK)
	_update_range_preview()


## resizes and recolors the editor ring; does nothing in game or before the ring exists
func _update_range_preview() -> void:
	if is_instance_valid(_range_preview_mesh_instance):
		var torus_mesh : TorusMesh = _range_preview_mesh_instance.mesh as TorusMesh
		# the outer edge is the detection range, measured from the same origin as the sight check
		torus_mesh.outer_radius = maxf(_detection_range, _RANGE_PREVIEW_WIDTH)
		torus_mesh.inner_radius = maxf(_detection_range - _RANGE_PREVIEW_WIDTH, 0.0)
		var material : StandardMaterial3D = _range_preview_mesh_instance.material_override as StandardMaterial3D
		material.albedo_color = _range_preview_color


## true if the given world position is within the detection range of the owner entity
func _is_target_in_range(target_position: Vector3) -> bool:
	# the origin is the same point the shapecast sweeps from
	var origin : Vector3 = _owner_controllable_entity.global_position
	# we compare that the target is inside a certain range
	return origin.distance_to(target_position) <= _detection_range


## checks the shapecast toward the given world position
func _is_shape_cast_colliding(target_position: Vector3) -> bool:
	# we set the shape cast target position
	_vision_shape_cast.target_position = _vision_shape_cast.to_local(target_position)
	# we update to see if there any collision
	_vision_shape_cast.force_shapecast_update()
	# the mask only includes things that block sight, so any collision blocks it
	return _vision_shape_cast.is_colliding()
