@tool
class_name Spatial1 extends Node3D

signal done

var auto_quit := true


class Inner:
	extends RefCounted

	class InnerEmpty:
		extends RefCounted

	static func fmt(value: String):
		return "Inner(%s)" % [value]


class InnerExtends:
	extends RefCounted

	func fmt(value: String):
		return "InterExtends(%s)" % [value]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Timer_timeout():
	print("add child")
	for i in range(2):
		await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().create_timer(.5).timeout
	emit_signal("done")
	if auto_quit:
		print("This line is not covered in the unit tests")
		get_tree().quit()
	else:
		print("This line is not covered in the CoverageTree tests")
