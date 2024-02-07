extends MarginContainer


#region vars
@onready var engine = $HBox/Engine
@onready var marker = $HBox/Marker
@onready var shard = $HBox/Shard

var crew = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	crew = input_.crew
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.racer = self
	#engine.set_attributes(input)
	
	input.type = "number"
	input.subtype = Global.num.index.racer
	marker.set_attributes(input)
	Global.num.index.racer += 1
	
	input.type = "number"
	input.subtype = -1
	shard.set_attributes(input)


func set_shard(shard_: Polygon2D) -> void:
	shard.set_number(shard_.index)
	shard_.set_racer(self)
#endregion


