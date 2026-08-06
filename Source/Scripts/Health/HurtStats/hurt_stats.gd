class_name DamageStats
extends Resource

## We use a local copy because we don't want the resource to be shared 
## between different entities, we want each entity to have its own values
func _init() -> void:
	resource_local_to_scene = true


## damage point to make to target
@export_range(1, 100) var damage : int = 10:
	get():
		return damage
	set(new_value):
		damage = max(new_value, 0)
