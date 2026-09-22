class_name EntityLevelConfig
extends Resource

## movement, damping and gravity stats for this level
@export var entity_stats: EntityStats
## health stats for this level
@export var health_stats: HealthStats
## weapon used at this level
@export var weapon_config: WeaponConfig
## color applied to this entity's body and turret meshes at this level
@export var entity_color: Color = Color.WHITE
