class_name WeaponConfig
extends Resource

## which scene to instantiate when this weapon is equipped
@export var weapon_scene: PackedScene
## which projectile to fire
@export var projectile_scene: PackedScene
## projectile configuration
@export var projectile_config: ProjectileConfig
## shooting cost configuration
@export var shooting_cost_config: ShootingCostConfig