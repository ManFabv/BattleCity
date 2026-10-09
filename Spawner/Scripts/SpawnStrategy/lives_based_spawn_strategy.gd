class_name LivesBasedSpawnStrategy
extends SpawnStrategyInterface

## the config with the lives, the respawn delay and the scene_to_spawn
var _lives_based_spawn_strategy_config : LivesBasedSpawnStrategyConfig
## the spawn point that instantiates every life
var _spawn_point : SpawnPoint
## used to clean up the respawn timers with the manager
var _owner_exited : Signal
## lives left, including the one currently spawned
var _remaining_lives : int:
	set(new_value):
		# we clamp the value so the lives never go below zero or above the starting lives
		_remaining_lives = clampi(new_value, 0, _lives_based_spawn_strategy_config.starting_lives)


## we cache the config
func _init(lives_based_spawn_strategy_config: LivesBasedSpawnStrategyConfig) -> void:
	# we cache the config so we can read the lives, delay and scene later
	_lives_based_spawn_strategy_config = lives_based_spawn_strategy_config


## at the beginning we spawn the first life
func configure(spawn_points: Array[SpawnPoint], owner_exited: Signal) -> void:
	# if there isn't exactly one spawn point we can't know where to respawn, so we don't start
	if spawn_points.size() != 1:
		push_error("lives based spawn strategy needs exactly one spawn point")
		return
	# we cache the only spawn point, every life spawns there
	_spawn_point = spawn_points[0]
	# we cache the owner exited signal so the respawn timers are cleaned up with the manager
	_owner_exited = owner_exited
	# we start with the configured amount of lives
	_remaining_lives = _lives_based_spawn_strategy_config.starting_lives
	# we spawn the first life right away
	_consume_life()


## spawns the next life and listens to its death
func _consume_life() -> void:
	# TODO: apply the saved level with set_initial_level() before spawn() emits, it needs a pre-emit callback
	# we spawn a new life at the spawn point
	var entity : ControllableEntity = _spawn_point.spawn(_lives_based_spawn_strategy_config.scene_to_spawn) as ControllableEntity
	# only a controllable entity tells us when it dies
	if is_instance_valid(entity):
		# we listen once to its death so we can respawn or run out of lives
		entity.subscribe_to_death(_on_entity_died)


## the current life died: we respawn after the delay or announce that the lives ran out
func _on_entity_died() -> void:
	# we lose the life that just died
	_remaining_lives -= 1
	# if there are no lives left we notify it and stop respawning
	if _remaining_lives == 0:
		_lives_based_spawn_strategy_config.emit_out_of_lives_event()
		return
	# we wait the respawn delay before spawning the next life
	_lives_based_spawn_strategy_config.timer_manager.create_one_shot(
			_lives_based_spawn_strategy_config.respawn_delay, 
			_consume_life, 
			_owner_exited)
