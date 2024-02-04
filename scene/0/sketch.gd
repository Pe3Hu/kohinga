extends MarginContainer


@onready var cradle = $Cradle
@onready var ruin = $Ruin


func _ready() -> void:
	var input = {}
	input.sketch = self
	cradle.set_attributes(input)
	ruin.set_attributes(input)
