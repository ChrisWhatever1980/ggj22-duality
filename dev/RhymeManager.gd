extends Node


var rhymes = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_rhymes()
	randomize()


func load_rhymes():
	var file = File.new()
	file.open("res://data/rhymes.csv", file.READ)
	while !file.eof_reached():
		var csv = file.get_csv_line ()
		if csv.size()>=2:
			rhymes.append([csv[0], csv[1]])
	file.close()
	print("added " + str(rhymes.size()) + "rhymes.")


func get_random_pair():
	var rand_rhyme = randi() % rhymes.size()
	return rhymes[rand_rhyme]


func get_random_rhyme():
	var rand_rhyme = randi() % rhymes.size()
	return rhymes[rand_rhyme][randi() % 2]
