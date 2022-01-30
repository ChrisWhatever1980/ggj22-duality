extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func show_dialog(text, word):
	visible = true
	$Label.text = text
	$Label2.text = word
	yield(get_tree().create_timer(5.0), "timeout")
	visible = false
