class_name Hurt
extends Area3D

## it's going to be triggered after dealing damage
signal _damage_dealt

## true after the first hit, or once disarmed; physics reports every overlap of the step before queue_free() frees us
var _has_dealt_damage : bool = false

## damage points applied to the health we collide with, set on configure
var _damage_points : int = 0:
	set(new_value):
		# we prevent negative values, which would heal the health we hit
		_damage_points = maxi(new_value, 0)


## to avoid having to connect this signal on every node, we connect it here
func _ready() -> void:
	area_entered.connect(_on_area_entered)


## we cache the damage points this hurt area deals
func configure(damage_points: int) -> void:
	_damage_points = damage_points


## stops this hurt from dealing damage, as if it had already dealt it (ex: a shield intercepted the projectile)
func disarm() -> void:
	# a disarmed hurt behaves as if it had already hit
	_has_dealt_damage = true


## deals the damage to the health, once
func _deal_damage(health: Health) -> void:
	# we only hurt once, even if two healths were touched in the same physics step
	if _has_dealt_damage:
		return
	# we mark the hit before dealing it
	_has_dealt_damage = true
	# we take damage when the body has a health component
	health.take_damage(_damage_points)
	# we notify that we collide with something
	_damage_dealt.emit()


## we subscribe to damage dealt signal
func subscribe_to_damage_dealt(on_damage_dealt: Callable) -> void:
	_damage_dealt.connect(on_damage_dealt)


## if we collided with other body
func _on_area_entered(health: Health) -> void:
	# deferred: a shield touching the projectile in this same physics step has to be able to disarm us first
	_deal_damage.call_deferred(health)
