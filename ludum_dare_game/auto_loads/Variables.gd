extends Node

# Used for input remapping and control displays
var user_keys = PoolStringArray(["pause", "pull", "up", "left", "down", "right"])

# Used for formatting strings to display the correct key.
var input_format = {}

var time := 0.0
