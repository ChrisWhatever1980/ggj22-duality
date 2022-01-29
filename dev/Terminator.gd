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
		area.update_label(3)


func _on_PerfectArea_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		perfect = false
		area.update_label(2)


func _on_GoodArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		good = true
		area.update_label(2)


func _on_GoodArea_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		good = false
		area.update_label(1)


func _on_OkayArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("note"):
		okay = true
		current_note = area
		area.update_label(1)


func _on_OkayArea_area_exited(area: Area2D) -> void:
	if area.is_in_group("note"):
		okay = false
		if current_note != null and !current_note.hit:
			get_parent().increment_score(0)
		current_note = null
		area.update_label(0)
		# player missed it by that much


func handle_input(pressed_rhyme):
	if current_note != null:
		if RhymeManager.compare_rhymes(pressed_rhyme, current_note.rhyme):
			if perfect:
				get_parent().increment_score(3)
				current_note.destroy(3)
			elif good:
				get_parent().increment_score(2)
				current_note.destroy(2)
			elif okay:
				get_parent().increment_score(1)
				current_note.destroy(1)
			reset()
		else:
			get_parent().increment_score(0)
