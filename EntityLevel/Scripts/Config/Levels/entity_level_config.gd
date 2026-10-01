class_name EntityLevelConfig
extends Resource

@export_group("Config")
## movement, damping and gravity stats for this level
@export var entity_stats: EntityStats
## health stats for this level
@export var health_stats: HealthStats
## weapon used at this level
@export var weapon_config: WeaponConfig
@export_group("Visuals")
## color applied to this entity's body mesh at this level
@export var entity_color: Color = Color.WHITE
