extends Node2D


func _on_Area2D_body_entered(body):
	if visible and body.is_in_group("player"):
		print("start_battle")
		GameEvents.emit_signal("start_battle", self)
