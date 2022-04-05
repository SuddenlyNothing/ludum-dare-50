extends Node2D

const Enemy := preload("res://scenes/characters/enemies/Enemy.tscn")

var player : Node
var targets_dict := {}


func set_info(res: Node, end: Node) -> void:
	player = res.player
	targets_dict[player] = 0
	targets_dict[end] = 0
	targets_dict[res] = 0


func _on_Timer_timeout() -> void:
	var enemy := Enemy.instance()
	enemy.position = position
	enemy.do_update_target = false
	enemy.target = player
	get_parent().add_child(enemy)
	enemy.targets = targets_dict
	enemy.update_target_timer.start()
