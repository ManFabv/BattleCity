class_name AudioSettingsResource
extends Resource
## the volume of each audio bus, applied to the AudioServer and kept between sessions in user://settings.cfg

## the file the settings are saved to, apart from the game progress
const _SETTINGS_PATH : String = "user://settings.cfg"
## the section of the settings file that holds the volumes
const _AUDIO_SECTION : String = "audio"

## linear volume (0 to 1) of each bus this resource controls, by bus name; the names come from default_bus_layout.tres
var _volumes_linear : Dictionary[StringName, float] = {&"Music": 1.0, &"SFX": 1.0}


## reads the saved volumes, if there are any, and applies every volume to its bus
func load_settings() -> void:
	var config_file : ConfigFile = ConfigFile.new()
	# a first run has no file yet, so the defaults stay
	if config_file.load(_SETTINGS_PATH) == OK:
		for bus_name : StringName in _volumes_linear:
			_volumes_linear[bus_name] = clampf(config_file.get_value(_AUDIO_SECTION, bus_name, 1.0), 0.0, 1.0)
	for bus_name : StringName in _volumes_linear:
		_apply_volume(bus_name)


## writes the current volumes to the settings file
func save_settings() -> void:
	var config_file : ConfigFile = ConfigFile.new()
	for bus_name : StringName in _volumes_linear:
		config_file.set_value(_AUDIO_SECTION, bus_name, _volumes_linear[bus_name])
	config_file.save(_SETTINGS_PATH)


## the linear volume (0 to 1) of the given bus
func get_volume_linear(bus_name: StringName) -> float:
	return _volumes_linear.get(bus_name, 1.0)


## sets and applies the linear volume (0 to 1) of the given bus; saving is up to the caller
func set_volume_linear(bus_name: StringName, volume_linear: float) -> void:
	_volumes_linear[bus_name] = clampf(volume_linear, 0.0, 1.0)
	_apply_volume(bus_name)


## sends the volume to its bus; the AudioServer converts the linear value to decibels, as the ear hears
func _apply_volume(bus_name: StringName) -> void:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	# a bus missing from the layout is a configuration error, not a reason to stop the game
	if bus_index >= 0:
		AudioServer.set_bus_volume_linear(bus_index, _volumes_linear[bus_name])
	else:
		push_error("AudioSettingsResource: the bus %s is not in the bus layout" % bus_name)
