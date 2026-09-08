extends NormalWeapon
class_name ChargedWeapon

@export var _charged_projectile_scene: PackedScene
@export var _charged_continuous_movement_scene: PackedScene
@export_range(0.1, 5.0) var _charge_duration: float = 1.0

var _charge_progress: float = 0.0
var _is_charging: bool = false


func process_weapon(delta: float) -> void:
	super.process_weapon(delta)
	if _is_charging:
		_charge_progress = minf(_charge_progress + delta / _charge_duration, 1.0)


func process_shot_input(_pressed: bool, just_pressed: bool, just_released: bool) -> void:
	if just_pressed:
		_is_charging = true
		_charge_progress = 0.0
	elif just_released:
		_is_charging = false


func fires_on_release() -> bool:
	return true


func try_shot(muzzle: Marker3D, on_projectile_spawned: BaseEvent) -> void:
	if _charge_progress < 1.0:
		super.try_shot(muzzle, on_projectile_spawned)
		_charge_progress = 0.0
		return
	var shot: Projectile = _charged_projectile_scene.instantiate() as Projectile
	shot.top_level = true
	on_projectile_spawned.emit(shot)
	shot.fire(muzzle, _charged_continuous_movement_scene)
	_charge_progress = 0.0
