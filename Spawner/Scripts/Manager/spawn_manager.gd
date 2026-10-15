class_name SpawnManager
extends Node

@export_group("References")
## spawn points managed by this manager
@export var _spawn_points : Array[SpawnPoint]
@export_group("Config")
## config of the strategy that decides when and where this manager spawns
@export var _spawn_strategy_config : SpawnStrategyConfig

## the strategy created from the config, the manager should owns it
var _spawn_strategy : SpawnStrategyInterface


## creates and starts the spawn strategy; called by the level root after this node's _ready()
func configure() -> void:
	# we keep the strategy alive for as long as the manager lives
	_spawn_strategy = _spawn_strategy_config.create_spawn_strategy()
	# the strategy starts right away (the timeline counts from here)
	_spawn_strategy.configure(_spawn_points, tree_exited)
