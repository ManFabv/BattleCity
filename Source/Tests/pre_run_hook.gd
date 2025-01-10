extends "res://addons/gut/hook_script.gd"

const Coverage = preload("res://addons/coverage/coverage.gd")
const EXCLUDE_PATHS = ["res://addons/*", "res://tests/*", "res://contrib/*", "res://Tests/pre_run_hook.gd", "res://Tests/post_run_hook.gd"]


func run():
	Coverage.new(gut.get_tree(), EXCLUDE_PATHS).instrument_scripts("res://").enforce_node_coverage()
