extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("Destination Global Position: ", $DestinationPoint.global_position)
	print("Player Initial Global Position: ", body.global_position)
	
	if body.is_in_group("Player"):
		body.set_position($DestinationPoint.global_position)
		# TODO: fix destination point incorrect position
