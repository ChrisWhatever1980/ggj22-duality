extends Area2D


var direction
var speed = 0
var hit = false
var rhyme

onready var labelHandle = $Node2D
onready var label = $Node2D/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if !hit:
		position += direction * speed * delta
		if position.y > 600:
			queue_free()
			#get_parent().reset_combo()
	else:
		labelHandle.position += Vector2.UP * speed * delta


func initialize(start, target, _speed, _rhyme):
	speed = _speed
	rhyme = _rhyme
	label.text = rhyme
	position = start
	direction = (target - start).normalized()


func destroy(score):

	label.modulate = Color.blue
	$AnimationPlayer.play("Pulse")
	$Particles2D.emitting = true

	$Timer.start()
	hit = true
	if score == 3:
		label.text = "GREAT"
	elif score == 2:
		label.text = "GOOD"
	elif score == 1:
		label.text = "OKAY"


func _on_Timer_timeout() -> void:
	queue_free()
