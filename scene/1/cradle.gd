extends MarginContainer


#region vars
@onready var trainers = $HBox/Trainers

var sketch = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_trainers()


func init_trainers() -> void:
	for _i in 1:
		var input = {}
		input.cradle = self
	
		var trainer = Global.scene.trainer.instantiate()
		trainers.add_child(trainer)
		trainer.set_attributes(input)
#endregion
