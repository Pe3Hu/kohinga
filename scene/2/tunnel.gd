extends Node2D


#region vars
var sector = null
var loop = null
var type = null
var direction = null
var shards = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	sector = input_.sector
	type = input_.type
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	loop = sector.loop
	var n = Global.dict.neighbor.linear2.size()
	var index = (sector.index + input_.deviation + n) % n
	direction = Global.dict.neighbor.linear2[index]
	
	for _i in input_.length:
		add_shard()


func add_shard() -> void:
	var input = {}
	input.tunnel = self
	input.grid = Vector2()
	input.parent = null
	
	if loop.shards.get_child_count() > 0:
		input.parent = loop.shards.get_child(loop.shards.get_child_count()-1)
		input.grid = input.parent.grid + direction

	var shard = Global.scene.shard.instantiate()
	loop.shards.add_child(shard)
	shard.set_attributes(input)
	shards.append(shard)
