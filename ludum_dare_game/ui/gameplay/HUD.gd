extends CanvasLayer

onready var health := $M/Health


func add_health(val: float) -> bool:
	return health.set_health(health.health + val)


func set_health(val: float) -> bool:
	return health.set_health(val)
