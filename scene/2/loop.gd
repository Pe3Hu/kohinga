extends MarginContainer


#region vars
@onready var shards = $Shards
@onready var tracks = $Tracks

var ruin = null
var grids = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	ruin = input_.ruin
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_shards()
	


func init_shards() -> void:
	var grid = Vector2()
	var primary = 5
	var secondary = 2
	var deviations = {}
	var n = Global.dict.neighbor.linear2.size()
	var deviation = null
	var old = null
	var l = Global.num.tunnel.n
	var shifts = [-1, 0, 1]
	
	for _i in 3:
		deviations[-1] = secondary
		
		for _j in l:
			for shift in shifts:
				if !deviations.has(shift):
					match shift:
						-1:
							deviations[shift] = secondary
						0:
							deviations[shift] = primary + secondary
						1:
							deviations[shift] = primary
			
			for shift in shifts:
				var index = (_i + shift + n + 1) % n
				var vec = Global.dict.neighbor.linear2[index]
				var temp = grid + vec
				
				if grids.has(temp):
					deviations.erase(shift)
			
			if _j == l - 1:
				deviations.erase(-1)
			
			if deviations.keys().is_empty():
				break
			
			if _i == 0 and _j == 0:
				pass
			else:
				deviation = Global.get_random_key(deviations)
				var index = (_i + deviation + n + 1) % n
				var vec = Global.dict.neighbor.linear2[index]
				grid += vec
			
			add_shard(grid)
	
	var x = abs(grid.x)
	var y = abs(grid.y)
	print([x,y, x +y])
	var _i = 3
	
	if x + y > l:
		compress_track()
	
	if x + y < l:
		stretch_track()
	
	grid = shards.get_child(shards.get_child_count() - 1).grid
	print(grid)
	
	if false:
		x = abs(grid.x)
		y = abs(grid.y)
		
		for _j in x + y:
			var d = abs(grid.x) + abs(grid.y)
			
			for shift in shifts:
				if !deviations.has(shift):
					match shift:
						-1:
							deviations[shift] = primary
						0:
							deviations[shift] = primary
						1:
							deviations[shift] = primary
			
				if deviations.keys().is_empty():
					break
				var index = (_i + shift + n + 1) % n
				var vec = Global.dict.neighbor.linear2[index]
				var temp = grid + vec
				var _d = abs(temp.x) + abs(temp.y)
				
				if grids.has(temp):
					deviations.erase(shift)
				
				if _d > d:
					deviations.erase(shift)
			
			if deviations.keys().is_empty():
				break
			
			deviation = Global.get_random_key(deviations)
			var index = (_i + deviation + n + 1) % n
			var vec = Global.dict.neighbor.linear2[index]
			grid += vec
			add_shard(grid)
		
	for shard in shards.get_children():
		shard.update_color_based_on_index()


func add_shard(grid_: Vector2) -> void:
	var input = {}
	input.loop = self
	input.grid = Vector2(grid_)
	input.parent = null
	
	if shards.get_child_count() > 0:
		input.parent = shards.get_child(shards.get_child_count()-1)

	var shard = Global.scene.shard.instantiate()
	shards.add_child(shard)
	shard.set_attributes(input)


func compress_track() -> void:
	var grid = shards.get_child(shards.get_child_count() - 1).grid
	var l = Global.num.tunnel.n
	var k = abs(grid.x) + abs(grid.y)
	
	
	while k > l:
		var options = []
		
		for track in tracks.get_children():
			if track.type == "direct":
				options.append(track)
			
		var option = options.pick_random()
		option.add_detour()
		k -= 2


func stretch_track() -> void:
	var grid = shards.get_child(shards.get_child_count() - 1).grid
	var l = Global.num.tunnel.n
	var k = abs(grid.x) + abs(grid.y)
	
	while k < l:
		k -= 1
#endregion
