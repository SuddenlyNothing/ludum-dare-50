extends Control

onready var earth_explode := $EarthExplode
onready var t := $Tween
onready var v := $V
onready var explosion_sfx := $ExplosionSFX
onready var time := $V/Time


func _ready() -> void:
	time.text = "Your time: " + str(int(Variables.time)) + "s"
	earth_explode.play("default")


func _on_EarthExplode_animation_finished() -> void:
	t.interpolate_property(v, "rect_position:y", null, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	t.start()


func _on_EarthExplode_frame_changed() -> void:
	match earth_explode.frame:
		7:
			explosion_sfx.play()
