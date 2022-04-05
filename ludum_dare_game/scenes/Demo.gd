extends Node2D

export(String, FILE, "*.tscn") var lose_screen

onready var respawn_plate := $RespawnPlate
onready var endpoint := $Endpoint
onready var death_timer := $DeathTimer
onready var perma_death_sfx := $PermaDeathSFX

var time := 0.0


func _ready() -> void:
	MusicPlayer.play("gameplay")
	get_tree().call_group("needs_info", "set_info", respawn_plate, endpoint)


func _physics_process(delta: float) -> void:
	time += delta


func _on_Endpoint_lost() -> void:
	if death_timer.is_stopped():
		death_timer.start()
		perma_death_sfx.play()


func _on_DeathTimer_timeout() -> void:
	Variables.time = time
	SceneHandler.goto_scene(lose_screen)


func _on_RespawnPlate_died() -> void:
	if death_timer.is_stopped():
		death_timer.start()
		perma_death_sfx.play()
