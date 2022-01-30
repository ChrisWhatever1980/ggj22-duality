extends Node2D


export var form = ""
export var word = ""

var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = load("res://gfx/words/" + form + ".png")


func _on_Area2D_body_entered(body):

	if !collected and body.is_in_group("player"):
		var text = ""
		if form == "crystal":
			text = "As you gaze at the crystal, a thought enters your mind:"
		if form == "tower":
			text = "At the top of the tower you find etched into the wall:"
		if form == "library":
			text = "You read from the last book in the library before it crumbles:"
		if form == "tomb":
			text = "A ghost from the tomb whispers at you before it vanishes:"

		GameEvents.emit_signal("unlock_word", text, word)

		collected = true
