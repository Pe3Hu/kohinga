extends Node2D


#region vars
var loop = null
var index = null
var tunnels = []
var tracks = []
var extents = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	loop = input_.loop
	
	init_basic_setting()


func init_basic_setting() -> void:
	index = loop.sectors.get_child_count() - 1
	
	for type in Global.arr.tunnel:
		extents[type] = 0
	
	init_tunnels()


func init_tunnels() -> void:
	if index == 3:
		var shard = loop.shards.get_child(loop.shards.get_child_count()-1)
		var grid = Vector2(shard.grid)
		
		if abs(grid.x) + abs(grid.y) > Global.num.sector.n or abs(grid.y) >= 10:
			loop.sectors.remove_child(self)
			queue_free()
			return
	
	var n = int(Global.num.sector.n)
	var lengths = {}
	lengths["mainstream"] = {}
	lengths["mainstream"][1] = 1
	lengths["mainstream"][2] = 3
	lengths["mainstream"][3] = 5
	
	lengths["external"] = {}
	lengths["external"][1] = 2
	lengths["external"][2] = 1
	
	lengths["internal"] = {}
	lengths["internal"][1] = 1
	lengths["internal"][2] = 2
	lengths["internal"][3] = 3
	
	var types = {}
	types[-1] = "external"
	types[0] = "mainstream"
	types[1] = "internal"
	
	var mainstream = true
	var input = {}
	input.sector = self
	var deviations = []
	
	if index > 1:
		var tunnel = loop.tunnels.get_child(loop.tunnels.get_child_count() - 1)
		
		if tunnel.type != "mainstream":
			var index = Global.dict.neighbor.linear2.find(tunnel.direction)
			
			if index == tunnel.sector.index - 1:
				deviations = [-1]
				mainstream = false
	
	var counter = 0
	
	while n > 0 and counter < Global.num.sector.n * 2:
		var flag = true
		
		while flag:
			match mainstream:
				true:
					input.deviation = 0
				false:
					if deviations.is_empty():
						deviations = [-1, 1]
					
					input.deviation = deviations.pick_random()
					deviations.erase(input.deviation)
			
			input.type = types[input.deviation]
			input.length = min(n, Global.get_random_key(lengths[input.type]))
			flag = overlap_check(input)
			counter += 1
			
			if flag:
				mainstream = !mainstream
			#else:
			#	desire_to_connect(input)
		
		if !mainstream and n - input.length < 3:
			if !deviations.is_empty():
				input.deviation = 1
		
		#if mainstream and n - input.length == 0 and index == 2:
			#var shard = loop.shards.get_child(loop.shards.get_child_count()-1)
			#var grid = Vector2(shard.grid) + Global.dict.neighbor.linear2[index] * input.length
			#
			#if abs(grid.x) + abs(grid.y) > Global.num.sector.n:
				#if input.length > 1:
					#input.length = 1
		
		var tunnel = Global.scene.tunnel.instantiate()
		loop.tunnels.add_child(tunnel)
		tunnel.set_attributes(input)
		tunnels.append(tunnel)
		n -= input.length
		mainstream = !mainstream
		extents[input.type] += input.length
		counter += 1
	
	var shard = loop.shards.get_child(loop.shards.get_child_count()-1)
	var grid = Vector2(shard.grid)


func overlap_check(input_: Dictionary) -> bool:
	if loop.shards.get_child_count() == 0:
		return false
	
	var shard = loop.shards.get_child(loop.shards.get_child_count() - 1)
	var grid = Vector2(shard.grid)
	
	var n = Global.dict.neighbor.linear2.size()
	var index = (index + input_.deviation + n) % n
	var direction = Global.dict.neighbor.linear2[index]
	
	for _i in input_.length:
		grid += direction
		
		if loop.grids.has(grid):
			return true
	
	return false


func desire_to_connect(input_: Dictionary) -> void:
	if index == 3:
		if input_.type != "mainstream":
			var limit = int(Global.num.sector.n)
			var deviations = [-1, 1]
			
			for deviation in deviations:
				var shard = loop.shards.get_child(loop.shards.get_child_count() - 1)
				var grid = Vector2(shard.grid)
				
				var n = Global.dict.neighbor.linear2.size()
				var index = (index + deviation + n) % n
				var direction = Global.dict.neighbor.linear2[index]
				grid += direction
				var distance = abs(grid.x) + abs(grid.y)
				
				if distance < limit:
					limit = distance
					input_.deviation = deviation
#endregion
