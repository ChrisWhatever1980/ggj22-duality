extends Node2D


var health = 50.0
var max_health = 50.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func take_damage(dmg):
	#print("Take damage: " + str(health) + " - " + str(dmg))
	health -= dmg
	if health < 0:
		health = 0
	$Bar.rect_scale.x = health / max_health
