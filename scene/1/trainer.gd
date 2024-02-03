extends MarginContainer


#region vars
@onready var members = $HBox/Members

var cradle = null
var battleground = null
var sequences = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_members()
	


func init_members() -> void:
	for _i in 1:
		var input = {}
		input.trainer = self
	
		var member = Global.scene.member.instantiate()
		members.add_child(member)
		member.set_attributes(input)
#endregion
