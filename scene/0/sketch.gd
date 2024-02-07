extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var ruin = $HBox/Ruin


func _ready() -> void:
	var input = {}
	input.sketch = self
	cradle.set_attributes(input)
	ruin.set_attributes(input)
	
	var loop = ruin.loops.get_child(0)
	
	for crew in cradle.crews.get_children():
		loop.add_crew(crew)
