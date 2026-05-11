extends Node

var player_position: Vector2

var Platform = OS.get_name()
enum scene_tree{
		MainMenu,
		GameScene,
		Settings,
		DeathScene,
		Paused
	}
class stateMachine:
	var current_scene: scene_tree
	#var scene_list: list[Scene]
	# constructor
	func stateMachine( default_scene: scene_tree = scene_tree.MainMenu):
		current_scene = default_scene
	
	#func switch_scene()
	
	# saving and continuing
	func save_state():
		pass
	
	func load_state():
		pass
	
#func _to_level(level: String):
	#var game_instance = game.instantiate()
	#game_instance.level_number = int(level)
	#get_tree().root.add_child(game_instance)
	#get_tree().current_scene = game_instance #You have to set the current scene for change_scene_to_file() to work later
	#queue_free()
