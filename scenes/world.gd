extends Node2D

const MAIN_MENU = preload("uid://2yvq6yiiep7y")
const TUTORIAL = preload("uid://cv0ml0hgsrwg4")
const LEVEL_1 = preload("uid://bwh2ryygpvbyx")
const END = preload("uid://pujirl51cm5p")

var level_node : Node2D

const levels : Array[PackedScene] = [
	MAIN_MENU,
	TUTORIAL,
	LEVEL_1,
	END,
]

var current_level: int = 0

func _ready():
	EventBus.switch_to_new_level.connect(go_to_next_level)
	var main_menu = MAIN_MENU.instantiate()
	level_node = main_menu
	add_child(main_menu)
	
func go_to_next_level():
	level_node.queue_free()
	var next_level = levels[current_level + 1].instantiate()
	add_child(next_level)
	level_node = next_level	
	current_level += 1
	
func start_over():
	EventBus.clear_flow()
	level_node.queue_free()
	var next_level = levels[0].instantiate()
	add_child(next_level)
	level_node = next_level
