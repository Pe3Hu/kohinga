extends MarginContainer


#region vars
@onready var crews = $HBox/Crews

var sketch = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_crews()


func init_crews() -> void:
	for _i in 5:
		var input = {}
		input.cradle = self
	
		var crew = Global.scene.crew.instantiate()
		crews.add_child(crew)
		crew.set_attributes(input)
#endregion
