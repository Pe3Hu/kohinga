extends MarginContainer


#region vars
@onready var tracks = $Tracks
@onready var sectors = $Sectors
@onready var tunnels = $Tunnels
@onready var shards = $Shards

var ruin = null
var grids = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	ruin = input_.ruin
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_sectors()
	


func init_sectors() -> void:
	var s = Global.dict.neighbor.linear2.size()
	
	while sectors.get_child_count() < s:
		reset()
		
		for _i in s:
			add_sector()
		
		var shard = shards.get_child(shards.get_child_count() - 1)
		var grid = Vector2(shard.grid)
		
		if !Global.dict.neighbor.linear2.has(grid):
			reset()
	
	var shard = shards.get_child(0)
	shard.parent = shards.get_child(shards.get_child_count() - 1)
	shard.init_track()
	


func reset() -> void:
	if sectors.get_child_count() > 0:
		print("reset")
		grids = {}
		
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
