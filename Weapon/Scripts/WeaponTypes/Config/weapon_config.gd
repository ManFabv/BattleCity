class_name WeaponConfig
extends Resource

@export_group("Scenes")
## which weapon type to instantiate when this weapon is equipped
@export var weapon_scene: PackedScene
## which projectile to fire
@export var projectile_scene: PackedScene
@export_group("Visuals")
## which scene to instantiate as this weapon's visual mesh, mounted as a child of the Weapon node
@export var weapon_mesh_scene: PackedScene
@export_group("Projectile")
## how each projectile moves (ex: a straight line at a speed)
@export var projectile_movement_config : ProjectileMovementConfig
## damage points each projectile deals
@export_range(1, 100) var projectile_damage_points : int = 10:
	set(new_value):
		# we prevent negative damage, which would heal the target
		projectile_damage_points = maxi(new_value, 0)
## seconds each projectile lives if it never hits anything nor leaves the screen
@export_range(1.0, 60.0) var projectile_lifetime_seconds : float = 10.0:
	set(new_value):
		# we need some time, or the projectile would be removed as soon as it's fired
		projectile_lifetime_seconds = maxf(new_value, 1.0)
@export_group("Shot")
## what each shot costs (ex: waiting between shots)
@export var shot_cost_config : ShotCostConfig
