class_name EnemyNavigationApplier
extends SpawnedNodeApplierInterface

@export_group("References")
## navigation region handed off to every spawned AIController
@export var _navigation_region : NavigationRegion3D


## we inject the region rid to the enemy's controller
func _apply(entity: ControllableEntity) -> void:
	var ai_controller : AIController = entity.get_entity_controller() as AIController
	if is_instance_valid(ai_controller):
		var navigation_region_rid : RID = _navigation_region.get_rid()
		ai_controller.set_navigation_region_rid(navigation_region_rid)
