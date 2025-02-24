extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://2d/game_1/scenes/stages/stage_1.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
