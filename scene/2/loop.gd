extends MarginContainer


#region vars
@onready var nodes = $Nodes
@onready var tracks = $Nodes/Tracks
@onready var sectors = $Nodes/Sectors
@onready var tunnels = $Nodes/Tunnels
@onready var shards = $Nodes/Shards

var ruin = null
var grids = {}
var crews  =[]
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	ruin = input_.ruin
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_sectors()
	


func init_sectors() -> void:
	var s = Global.dict.neighbor.linear2.size()
	var shard = null
	
	while sectors.get_child_count() < s:
		reset()
		
		for _i in s:
			add_sector()
		
		if shards.get_child_count() != s * Global.num.sector.n:
			reset()
		else:
			shard = shards.get_child(shards.get_child_count() - 1)
			var grid = Vector2(shard.grid)
			
			if !Global.dict.neighbor.linear2.has(grid):
				reset()
	
	#print("no more reset")
	shard = shards.get_child(0)
	shard.parent = shards.get_child(shards.get_child_count() - 1)
	shard.init_track()
	
	var corners = {}
	corners.min = Vector2.ONE * Global.num.sector.n
	corners.max = Vector2()
	
	for _shard in shards.get_children():
		if _shard.grid.x < corners.min.x:
			corners.min.x = _shard.grid.x
		if _shard.grid.y < corners.min.y:
			corners.min.y = _shard.grid.y
		if _shard.grid.x > corners.max.x:
			corners.max.x = _shard.grid.x
		if _shard.grid.y > corners.max.y:
			corners.max.y = _shard.grid.y
	
	corners.min -= Vector2.ONE
	#corners.max += Vector2.ONE
	nodes.position = -corners.min * Global.vec.size.shard
	nodes.position -= Vector2.ONE * Global.num.shard.l * 0.25
	custom_minimum_size = (corners.max - corners.min) * Global.vec.size.shard
	


func reset() -> void:
	if sectors.get_child_count() > 0:
		#print("reset")
		grids = {}
		Global.num.index.shard = 0
		
		while sectors.get_child_count() > 0:
			var sector = sectors.get_child(0)
			
			for tunnel in sector.tunnels:
				for shard in tunnel.shards:
					shards.remove_child(shard)
					shard.queue_free()
				
				tunnels.remove_child(tunnel)
				tunnel.queue_free()
				
			sectors.remove_child(sector)
			sector.queue_free()
		
		while tracks.get_child_count() > 0:
			var track = tracks.get_child(0)
			tracks.remove_child(track)
			track.queue_free()


func add_sector() -> void:
	var input = {}
	input.loop = self
	
	var sector = Global.scene.sector.instantiate()
	sectors.add_child(sector)
	sector.set_attributes(input)
#endregion


func add_crew(crew_: MarginContainer) -> void:
	crews.append(crew_)
	
	if crews.size() == 5:
		seat_lottery()


func seat_lottery() -> void:
	var distributions = {}
	var weights = {}
	var avg = shards.get_child_count() / 2
	
	for shard in shards.get_children():
		weights[shard] = avg - abs(shard.index - avg) + 1
	
	for crew in crews:
		distributions[crew] = crew.racers.get_child_count() + 1
	
	
	while !distributions.keys().is_empty():
		var crew = Global.get_random_key(distributions)
		distributions[crew] -= 1
		
		if distributions[crew] > 1:
			var shard = Global.get_random_key(weights)
			crew.shards.append(shard)
			weights.erase(shard)
		else:
			match distributions[crew]:
				0:
					distributions.erase(crew)
				1:
					var data = {}
					data.shard = weights.keys().front()
					data.sum = 0
					
					for shard in crew.shards:
						data.sum += shard.index
					
					data.avg = (data.sum + data.shard.index) / (crew.shards.size() + 1)
					
					for shard in weights.keys():
						var _avg = (data.sum + shard.index) / (crew.shards.size() + 1)
						
						if abs(avg - data.avg) > abs(avg - _avg):
							data.shard = shard
							data.avg = _avg
					
					crew.shards.append(data.shard)
					weights.erase(data.shard)
		
	for crew in crews:
		crew.shards.sort_custom(func(a, b): return a.index < b.index)
		
		for _i in crew.shards.size():
			var shard = crew.shards[_i]
			var racer = crew.racers.get_child(_i)
			racer.set_shard(shard)
