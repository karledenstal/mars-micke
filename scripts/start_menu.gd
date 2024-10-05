extends Control

@export var start_scene: PackedScene = null

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_packed(start_scene)

func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
