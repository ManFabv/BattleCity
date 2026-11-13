class_name LevelHud
extends CanvasLayer
## shows the lives the player has left and the enemies left to eliminate; it only listens to events that already carry the values

@export_group("Events")
## event with the lives the player has left, emitted when the level starts and on every death
@export var _on_player_lives_changed : BaseEvent
## event with the enemies left to eliminate in the level (still to spawn plus alive), emitted when the timeline starts and on every death
@export var _on_enemies_remaining_changed : BaseEvent

@export_group("References")
## the label that shows the lives left
@export var _lives_label : Label
## the label that shows the enemies left to eliminate
@export var _enemies_label : Label


## we listen to both counts and stay hidden until the lives are known, which happens when the player first spawns
func _ready() -> void:
	_on_player_lives_changed.subscribe(_on_player_lives_changed_handler, tree_exited)
	_on_enemies_remaining_changed.subscribe(_on_enemies_remaining_changed_handler, tree_exited)
	hide()


## the player lost or got a life: we show what is left
func _on_player_lives_changed_handler(remaining_lives: int) -> void:
	_lives_label.text = "Vidas: %d" % remaining_lives
	# the first lives event comes with the first spawn of the player, after the start prompt
	show()


## the timeline started or an enemy died: we show how many are left
func _on_enemies_remaining_changed_handler(enemies_remaining_count: int) -> void:
	_enemies_label.text = "Enemigos: %d" % enemies_remaining_count
