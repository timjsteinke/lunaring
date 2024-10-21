extends Node

var current_scene = null

func _ready()-> void:
	var root = get_tree().root
	current_scene = root.get_child(get_child_count() - 1)
	
# Usage: 
# SceneSwitcher.switch_scene("whatever_scene")

func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
		
	
func _deferred_switch_scene(res_path):
	var game_data = current_scene.game_data
	current_scene.free()
	var new_scene = load("res://scenes/" + res_path  + ".tscn")
	current_scene = new_scene.instantiate()
	current_scene.set_game_data(game_data)	 
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
