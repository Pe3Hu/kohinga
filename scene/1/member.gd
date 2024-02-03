extends MarginContainer


#region vars
@onready var health = $HBox/Aspects/Health
@onready var speed = $HBox/Aspects/Speed
@onready var attack = $HBox/Aspects/Attack
@onready var energy = $HBox/Aspects/Energy

var trainer = null
var index = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	trainer = input_.trainer
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_aspects()


func init_aspects() -> void:
	for type in Global.arr.aspect:
		var input = {}
		input.member = self
		input.type = type
		input.limit = 30
		
		var aspect = get(type)
		aspect.set_attributes(input)
#endregion


