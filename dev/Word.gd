extends VBoxContainer


export var key = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Key.texture = load("res://gfx/btn_" + str(key) + ".png")
