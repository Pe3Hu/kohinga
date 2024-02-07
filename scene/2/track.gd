extends Line2D


#region vars
var loop = null
var shards = null
var type = null
var subtype = null
var parent = null
var child = null
var direction = null
var sector = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	loop = input_.loop
	shards = input_.shards
	
	init_basic_setting()


func init_basic_setting() -> void:
	update_points()
	
	for shard in shards:
		if shards.has(shard.child):
			parent = shard
			child = shard.child
			break
	
	parent.tracks[self] = child
	child.tracks[self] = parent
	
	parent.neighbors[child] = self
	child.neighbors[parent] = self
	
	direction = child.grid - parent.grid
	sector = max(child.tunnel.sector.index, parent.tunnel.sector.index)
	sector = loop.sectors.get_child(sector)
	sector.tracks.append(self)
	subtype = "primary"


func set_type(type_: String) -> void:
	if type != "bend":
		type = type_
		
		match type:
			"direct":
				default_color = Color.BLACK
			"bend":
				default_color = Color.WHITE


func update_points() -> void:
	points = []
	
	for shard in shards:
		var vertex = shard.position - Vector2.ONE * Global.num.shard.l# * 0.5
		add_point(vertex)


func crush() -> void:
	for shard in shards:
		shard.tracks.erase(self)
		
		for neighbor in shard.neighbors:
			if shard.neighbors[neighbor]:
				shard.neighbors.erase(neighbor)
				break
	
	loop.tracks.remove_child(self)
	queue_free()
#endregion


func add_detour() -> void:
	var directions = {}
	var x = shards.front().grid.x - shards.back().grid.x
	var y = shards.front().grid.y - shards.back().grid.y
	
	for _direction in Global.dict.neighbor.linear2:
		if abs(_direction.x) != abs(x) and abs(_direction.y) != abs(y):
			var flag = true
			directions[_direction] = []
			
			for shard in shards:
				var grid = shard.grid + _direction
				
				flag = flag and  !loop.grids.has(grid)
				directions[_direction].append(grid)
			
			if !flag:
				directions.erase(_direction)
	
	var _direction = directions.keys().pick_random()
	
	var grids = {}
	grids.first = parent.grid + _direction
	grids.second = grids.first + direction
	
	var pairs = []
	pairs.append([parent.grid, grids.first])
	pairs.append([grids.first, grids.second])
	pairs.append([grids.second, child.grid])
	
	for pair in pairs:
		add_shard(pair)


func add_shard(pair_: Array) -> void:
	var a = loop.grids[pair_.front()]
	
	if !loop.grids.has(pair_.back()):
		var input = {}
		input.loop = loop
		input.grid = Vector2(pair_.back())
		input.parent = a
		
		var shard = Global.scene.shard.instantiate()
		loop.shards.add_child(shard)
		shard.set_attributes(input)
	else:
		var b = loop.grids[pair_.back()]
		b.parent = a
		a.init_track()
