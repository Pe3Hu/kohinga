extends MarginContainer


#region vars
@onready var health = $Aspects/Health
@onready var speed = $Aspects/Speed
@onready var attack = $Aspects/Attack
@onready var energy = $Aspects/Energy

var racer = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	racer = input_.racer
	
	init_basic_setting()


func init_basic_setting() -> void:
	#init_aspects()
	pass


func init_aspects() -> void:
	for type in Global.arr.aspect:
		var input = {}
		input.member = self
		input.type = type
		input.limit = 30
		
		var aspect = get(type)
		aspect.set_attributes(input)
