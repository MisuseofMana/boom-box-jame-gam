extends Node2D

const MAIN_MENU = preload("uid://2yvq6yiiep7y")
const TUTORIAL = preload("uid://cv0ml0hgsrwg4")
const LEVEL_1 = preload("uid://bwh2ryygpvbyx")
const END = preload("uid://pujirl51cm5p")

@export var levels: Array[PackedScene]

var level_node : Node2D

var current_level: int = 0

func _ready():
	EventBus.switch_to_new_level.connect(go_to_next_level)
	EventBus.reset_level.connect(restart_level)
	var main_menu = MAIN_MENU.instantiate()
	level_node = main_menu
	add_child(main_menu)
	
func go_to_next_level():
	level_node.queue_free()
	var next_level = levels[current_level + 1].instantiate()
	add_child(next_level)
	level_node = next_level	
	current_level += 1
	
func restart_level():
	level_node.queue_free()
	var same_level = levels[current_level].instantiate()
	add_child(same_level)
	level_node = same_level	
	
