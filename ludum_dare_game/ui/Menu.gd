extends Control


func _ready() -> void:
	MusicPlayer.play("menu")


func _on_Settings_pressed() -> void:
	OptionsMenu.set_active(true)
