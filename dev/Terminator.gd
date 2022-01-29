extends ColorRect


var perfect = false
var good = false
var okay = false
var current_note = null


func reset():
	current_note = null


func _on_PerfectArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		perfect = true


func _on_PerfectArea_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		perfect = false


func _on_GoodArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		good = true


func _on_OkayArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		okay = true
		current_note = area


func _on_OkayArea_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		okay = false
		current_note = null


func _on_GoodArea_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		good = false


func handle_input(pressed_rhyme):
	if current_note != null:
		if current_note.rhyme == pressed_rhyme:
			if perfect:
				get_parent().increment_score(3)
				current_note.rhyme.destroy(3)
			elif good:
				get_parent().increment_score(2)
				current_note.rhyme.destroy(2)
			elif okay:
				get_parent().increment_score(1)
				current_note.rhyme.destroy(1)
			reset()
		else:
			get_parent().increment_score(0)
