class_name WeaponConfig
extends Resource

## which scene to instantiate when this weapon is equipped
@export var weapon_scene: PackedScene
## which scene to instantiate as this weapon's visual mesh, mounted as a child of the
## Weapon node. REQUIRED: root must be a MeshInstance3D with a child Marker3D named
## "Muzzle" (unique_name_in_owner) -- that Muzzle is where this weapon's projectiles spawn from.
@export var weapon_mesh_scene: PackedScene
## color applied to the weapon mesh above
@export var weapon_color: Color = Color.WHITE
## which projectile to fire
@export var projectile_scene: PackedScene
## projectile configuration
@export var projectile_config: ProjectileConfig
## shooting cost configuration
@export var shooting_cost_config: ShootingCostConfig