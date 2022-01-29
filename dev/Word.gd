extends Node2D


export var key = 0


onready var word_label = $VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Key.text = str(key)


func hit():
	$AnimationPlayer.play("Pulse")
