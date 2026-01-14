extends Node2D

@export var letter_gap := 10.0

var _letter_scene := preload("res://scenes/letter/letter.tscn")
var _letter_offset := 64
var _remaining_letters: Array[Node]


func set_letters(word: String) -> void:
	assert(word.length() > 0, "Word is empty")
	var letters := word.split("")
	for i in letters.size():
		var letter := _letter_scene.instantiate()
		letter.position.x += _letter_offset * i
		letter.letter = letters[i]
		_remaining_letters.append(letter)
		add_child(letter)


func reveal_letter(letter_to_reveal: String) -> void:
	var get_first_occurrence := func (l: Node): return l.letter == letter_to_reveal and not l.is_revealed
	var letter_index := _remaining_letters.find_custom(get_first_occurrence.bind())
	if (letter_index == -1):
		return

	var letter = _remaining_letters.get(letter_index)
	letter.reveal()
