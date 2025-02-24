extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.set_position($DestinationPoint.global_position)
	# TODO: fix destination point incorrect position
