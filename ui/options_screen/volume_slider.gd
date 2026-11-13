class_name VolumeSlider
extends HSlider
## slider of the linear volume (0 to 1) of one audio bus; the change is heard right away

@export_group("References")
## the shared settings the volume is read from and written to
@export var _audio_settings : AudioSettingsResource

@export_group("Config")
## the bus of default_bus_layout.tres this slider controls
@export var _bus_name : StringName = &"Music"


## we start at the saved volume and follow every change
func _ready() -> void:
	value = _audio_settings.get_volume_linear(_bus_name)
	value_changed.connect(_on_value_changed)


## the slider moved: the bus takes the new volume
func _on_value_changed(new_value: float) -> void:
	_audio_settings.set_volume_linear(_bus_name, new_value)
