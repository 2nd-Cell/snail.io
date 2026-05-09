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
	
