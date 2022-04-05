extends Node2D

export(String, FILE, "*.tscn") var level
export(Array, String, MULTILINE) var d1
export(Array, String, MULTILINE) var d2
export(Array, String, MULTILINE) var d3
export(Array, String, MULTILINE) var d4

onready var dialog_player := $CanvasLayer/DialogPlayer
onready var enemy := $Enemy


func _ready() -> void:
	dialog_player.read(d1)
	enemy.do_update_target = false


func _on_Area2D_body_entered(_body: Node) -> void:
	dialog_player.read(d2)


func _on_Area2D2_body_entered(body: Node) -> void:
	dialog_player.read(d3)


func _on_Area2D3_body_entered(body: Node) -> void:
	dialog_player.read(d4)
	yield(dialog_player, "dialog_finished")
	SceneHandler.goto_scene(level)
	
