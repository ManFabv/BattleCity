class_name WeaponConfig
extends Resource

@export_group("Scenes")
## which scene to instantiate when this weapon is equipped
@export var weapon_scene: PackedScene
## which projectile to fire
@export var projectile_scene: PackedScene
@export_group("Visuals")
## which scene to instantiate as this weapon's visual mesh, mounted as a child of the
## Weapon node. REQUIRED: root must use the WeaponMesh script (extends MeshInstance3D)
## with its muzzle export assigned -- that Muzzle is where this weapon's projectiles spawn from.
@export var weapon_mesh_scene: PackedScene
## color applied to the weapon mesh above
@export var weapon_color: Color = Color.WHITE
@export_group("Projectile")
## units per second each projectile moves
@export_range(0.1, 100.0) var projectile_max_speed : float = 10.0
## damage points each projectile deals
@export_range(1, 100) var projectile_damage_points : int = 10
@export_group("Config")
## shooting cost configuration
@export var shooting_cost_config: ShootingCostConfig