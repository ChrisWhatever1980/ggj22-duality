extends KinematicBody2D


var collected_words = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D/DialogBox.visible = false


func word_collected(word):
	collected_words.append(word)


func _physics_process(delta):
	
	var move = Vector2.ZERO

	if Input.is_action_pressed("walk_north"):
		move.y -= 1
	if Input.is_action_pressed("walk_south"):
		move.y += 1
	if Input.is_action_pressed("walk_east"):
		move.x += 1
	if Input.is_action_pressed("walk_west"):
		move.x -= 1

	var velocity = move_and_slide(move * 100.0)

	if velocity.y < 0.0:
		$AnimatedSprite.play("walk_north")
	elif velocity.y > 0.0:
		$AnimatedSprite.play("walk_south")
	elif velocity.x > 0.0:
		$AnimatedSprite.play("walk_side")
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0.0:
		$AnimatedSprite.play("walk_side")
		$AnimatedSprite.flip_h = true
	
	if velocity.length() == 0.0:
		$AnimatedSprite.play("stand")
