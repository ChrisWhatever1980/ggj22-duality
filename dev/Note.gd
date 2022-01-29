extends Area2D


var direction
var speed = 100
var hit = false
var rhyme

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
		$Node2D.position -= direction * speed * delta


func initialize(start, target, _rhyme):
	rhyme = _rhyme
	$Label.text = rhyme
	position = start
	direction = (target - start).normalized()


func destroy(score):
	$Timer.start()
	hit = true
	if score == 3:
		$Node2D/Label.text = "GREAT"
		$Node2D/Label.modulate = Color("f6d6bd")
	elif score == 2:
		$Node2D/Label.text = "GOOD"
		$Node2D/Label.modulate = Color("c3a38a")
	elif score == 1:
		$Node2D/Label.text = "OKAY"
		$Node2D/Label.modulate = Color("997577")


func _on_Timer_timeout() -> void:
	queue_free()
