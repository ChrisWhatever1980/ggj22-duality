extends Area2D


func _on_MuteAmbienceBox_body_entered(body):
	print("mute true")
	if body.is_in_group("player"):
		GameEvents.emit_signal("mute_ambience", true)


func _on_MuteAmbienceBox_body_exited(body):
	print("mute true")
	if body.is_in_group("player"):
		GameEvents.emit_signal("mute_ambience", false)
