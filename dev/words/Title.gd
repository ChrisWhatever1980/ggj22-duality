extends Node2D


func _ready():
	visible = false
	$AnimationPlayer.play("RESET")
	yield(get_tree().create_timer(1.5), "timeout")
	visible = true
	$AnimationPlayer.play("TitleAnim")

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene("res://World.tscn")
