@tool
class_name SpawnManager
extends Node

@export_group("References")
## spawn points managed by this manager
@export var _spawn_points : Array[SpawnPoint]:
	set(new_value):
		_spawn_points = new_value
		# we refresh the warnings in the editor
		_update_editor_warnings()
@export_group("Config")
## config of the strategy that decides when and where this manager spawns
@export var _spawn_strategy_config : SpawnStrategyConfig:
	set(new_value):
		_spawn_strategy_config = new_value
		# we refresh the warnings in the editor
		_update_editor_warnings()

## the strategy created from the config, the manager should owns it
var _spawn_strategy : SpawnStrategyInterface


## the editor flags a missing config or a config that can't start with these spawn points
func _get_configuration_warnings() -> PackedStringArray:
	# we collect everything that is wrong
	var warnings : PackedStringArray = PackedStringArray()
	# without a config there is no strategy to start
	if is_instance_valid(_spawn_strategy_config):
		# the config knows what its strategy needs from the spawn points
		warnings.append_array(_spawn_strategy_config.get_configuration_warnings(_spawn_points))
	else:
		warnings.append("the spawn manager needs a spawn strategy config")
	# an empty slot can't spawn anything
	if _spawn_points.has(null):
		warnings.append("the spawn manager has an empty spawn point slot")
	return warnings


## creates and starts the spawn strategy; called by the level root after this node's _ready()
func start() -> void:
	# a config that can't start is reported and the strategy is not created
	var warnings : PackedStringArray = _get_configuration_warnings()
	# every warning is an error at runtime
	for warning : String in warnings:
		push_error("SpawnManager: %s" % warning)
	# nothing is spawned while the config has warnings
	if warnings.is_empty():
		# we keep the strategy alive for as long as the manager lives
		_spawn_strategy = _spawn_strategy_config.create_spawn_strategy()
		# the strategy starts right away (the timeline counts from here)
		_spawn_strategy.start(_spawn_points, tree_exited)


## asks the editor to refresh the warnings of this node
func _update_editor_warnings() -> void:
	# only the editor shows warnings
	if Engine.is_editor_hint():
		# we ask the editor to call _get_configuration_warnings() again
		update_configuration_warnings()
