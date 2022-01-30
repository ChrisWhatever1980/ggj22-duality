extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Input.is_action_pressed("walk_north"):
		$AnimatedSprite.play("walk_north")
		position.y -= 1
	if Input.is_action_pressed("walk_south"):
		$AnimatedSprite.play("walk_south")
		position.y += 1
	if Input.is_action_pressed("walk_east"):
		$AnimatedSprite.play("walk_side")
		$AnimatedSprite.flip_h = false
		position.x += 1
	if Input.is_action_pressed("walk_west"):
		$AnimatedSprite.play("walk_side")
		$AnimatedSprite.flip_h = true
		position.x -= 1
