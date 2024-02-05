extends MarginContainer


#region vars
@onready var shards = $Shards
@onready var tracks = $Tracks

var ruin = null
var grids = {}
var sectors = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	ruin = input_.ruin
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_shards()
	


func init_shards() -> void:
	var grid = Vector2()
	var s = Global.dict.neighbor.linear2.size()
	
	for _i in Global.dict.neighbor.linear2.size():
		sectors[_i] = []
		
		for _j in Global.num.tunnel.m:
			#if _i == 0 and _j == 0:
				#pass
			#else:
			grid += Global.dict.neighbor.linear2[_i]
			add_shard(grid, _i)
	
	
	var _shard = shards.get_child(0)
	_shard.parent = shards.get_child(shards.get_child_count()-1)
	_shard.update_type()
	_shard.init_track()
	
	for shard in shards.get_children():
		for track in shard.tracks:
			track.set_type(shard.type)
	
	stretch_tracks()
	#for shard in shards.get_children():
	#	shard.update_color_based_on_index()


func add_shard(grid_: Vector2, sector_: int) -> void:
	var input = {}
	input.loop = self
	input.grid = Vector2(grid_)
	input.sector = sector_
	input.parent = null
	
	if shards.get_child_count() > 0:
		input.parent = shards.get_child(shards.get_child_count()-1)

	var shard = Global.scene.shard.instantiate()
	shards.add_child(shard)
	shard.set_attributes(input)


func stretch_tracks() -> void:
	var l = Global.num.tunnel.n - Global.num.tunnel.m
	var breaches = {}
	var n = Global.dict.neighbor.linear2.size()
	
	for _i in n:
		breaches[_i] = l
	
	var detours = {}
	detours[1] = 9
	detours[2] = 4
	detours[4] = 1
	
	while !breaches.keys().is_empty():
		var breach = 1#Global.get_random_key(breaches)
		var mirror = (breach + n / 2) % n
		var _sectors = [breach, mirror]
		var detour = 1#Global.get_random_key(detours)
		
			
		match detour:
			1:
				var shards = []
				
				for sector in _sectors:
					var track = sectors[sector].front()#sectors[sector].pick_random()
					shards.append(track.child)
				
				displacement(shards)
				shards.append(shards.front())
				shards.pop_front()
				displacement(shards)
				
				for shard in shards:
					var track = shard.neighbors[shard.parent]
					track.crush()
				#	shard.add_extension()
		
		breaches = {}
	
	for track in tracks.get_children():
		track.update_points()


func add_detour(sector_: int, detour_: int) -> void:
	var _tracks = []
	_tracks.append_array(sectors[sector_])
	var track = _tracks[0]#_tracks.pick_random()
	var child = track.child
	

func displacement(shards_: Array) -> void:
	var shard = shards_.front()
	var gap = Global.dict.neighbor.linear2[shard.sector]
	shard.grid += gap * 1.5
	shard.position = shard.grid * Global.vec.size.shard
	print("~")
	
	while shard.child != shards_.back():
		shard = shard.child
		
		if shard.sector != shard.child.sector:
			var index = (shard.sector + 1) % Global.dict.neighbor.linear2.size()
			gap = Global.dict.neighbor.linear2[index]
		
		shard.grid = shard.parent.grid + gap
		shard.position = shard.grid * Global.vec.size.shard


func add_extension(shard_: Polygon2D) -> void:
	shard_.tracks[shard_] = null
	var input = {}
	input.loop = self
	input.grid = shard_.grid + Global.dict.neighbor.linear2[shard_.sector]
	input.sector = shard_.sector
	input.parent = shard_

	var shard = Global.scene.shard.instantiate()
	shards.add_child(shard)
	shard.set_attributes(input)
#endregion
