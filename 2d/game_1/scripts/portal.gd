extends Area2D

func _on_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("Player"):
		await get_tree().process_frame
		body.global_position = $DestinationPoint.global_position
