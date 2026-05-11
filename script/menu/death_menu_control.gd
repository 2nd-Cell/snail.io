extends Control


func _on_button_pressed() -> void:
	print("Helllo World")
	LoadingScreen.change_scene("res://scene/main/Menu_Scene.tscn")
