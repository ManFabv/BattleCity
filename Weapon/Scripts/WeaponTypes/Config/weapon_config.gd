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
## color applied to the weapon mesh above
@export var weapon_color: Color = Color.WHITE
@export_group("Projectile")
## units per second each projectile moves
@export_range(0.1, 100.0) var projectile_max_speed : float = 10.0:
	set(new_value):
		# we prevent negative speeds, which would move the projectiles backwards
		projectile_max_speed = maxf(new_value, 0.0)
## damage points each projectile deals
@export_range(1, 100) var projectile_damage_points : int = 10:
	set(new_value):
		# we prevent negative damage, which would heal the target
		projectile_damage_points = maxi(new_value, 0)
@export_group("Shot")
## seconds the weapon waits between shots
@export_range(0.1, 10.0) var fire_rate_seconds : float = 1.0:
	set(new_value):
		# we prevent negative cooldowns
		fire_rate_seconds = maxf(new_value, 0.0)
