extends MarginContainer


#region vars
@onready var racers = $HBox/Racers

var cradle = null
var loop = null
var shards = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_racers()
	


func init_racers() -> void:
	for _i in 3:
		var input = {}
		input.crew = self
	
		var racer = Global.scene.racer.instantiate()
		racers.add_child(racer)
		racer.set_attributes(input)
#endregion
