extends MarginContainer


#region vars
@onready var bar = $HBox/ProgressBar
@onready var limit = $HBox/Limit
@onready var icon = $HBox/Icon

var member = null
var type = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	member = input_.member
	type = input_.type
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	var input = {}
	input.type = "aspect"
	input.subtype = type
	icon.set_attributes(input)
	icon.custom_minimum_size = Vector2(Global.vec.size.icon)
	
	input.type = "number"
	input.subtype = 0
	limit.set_attributes(input)
	limit.custom_minimum_size = Vector2(Global.vec.size.icon)
	update_value("maximum", input_.limit)
	update_value("current", 0)
	set_colors()
	#custom_minimum_size = Vector2(Global.vec.size.aspect)
	bar.custom_minimum_size = Vector2(Global.vec.size.bar)
	


func set_colors() -> void:
	var keys = ["fill", "background"]
	
	for key in keys:
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Global.color.bar[type][key]
		var path = "theme_override_styles/" + key
		bar.set(path, style_box)
#endregion


func update_value(value_: String, shift_: int) -> void:
	match value_:
		"current":
			bar.value += shift_
		"maximum":
			bar.max_value = shift_
			limit.set_number(bar.max_value)


func get_percentage() -> int:
	return floor(bar.value * 100 / bar.max_value)


func reset() -> void:
	bar.value = bar.max_value
