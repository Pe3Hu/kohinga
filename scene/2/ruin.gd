extends MarginContainer


#region vars
@onready var loops = $Loops

var sketch = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_loops()


func init_loops() -> void:
	for _i in 1:
		var input = {}
		input.ruin = self
	
		var loop = Global.scene.loop.instantiate()
		loops.add_child(loop)
		loop.set_attributes(input)
#endregion
