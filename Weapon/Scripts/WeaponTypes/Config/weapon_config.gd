class_name WeaponConfig
extends Resource

## which scene to instantiate when this weapon is equipped
@export var weapon_scene: PackedScene
## which projectile to fire
@export var projectile_scene: PackedScene
## which movement strategy this projectile uses
@export var continuous_movement_scene: PackedScene
## which shooting cost strategy this weapon uses
@export var shooting_cost_strategy_scene: PackedScene