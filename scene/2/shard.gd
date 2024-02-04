extends Polygon2D


#region vars

var loop = null
var grid = null
var index = null
var parent = null
var child = null
var type = null
var tracks = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	loop = input_.loop
	grid = input_.grid
	parent = input_.parent
	
	init_basic_setting()


func init_basic_setting() -> void:
	loop.grids[grid] = self
	position = grid * Global.vec.size.shard
	index = int(Global.num.index.shard)
	Global.num.index.shard += 1
	set_vertexs()
	init_track()
	update_color_based_on_index()


func set_vertexs() -> void:
	var order = "odd"
	var corners = 4
	var r = Global.num.shard.r
	var vertexs = []
	
	for corner in corners:
		var vertex = Global.dict.corner.vector[corners][order][corner] * r
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func init_track() -> void:
	if parent != null:
		parent.child = self
		parent.update_type()
		var input = {}
		input.loop = loop
		input.shards = [parent, self]
	
		var track = Global.scene.track.instantiate()
		loop.tracks.add_child(track)
		track.set_attributes(input)


func update_color_based_on_index() -> void:
	var hue = float(index) / (Global.num.index.shard)
	color = Color.from_hsv(hue, 0.9, 0.7)
	
	if index % Global.num.tunnel.n == 0:
		color = Color.BLACK


func update_type() -> void:
	if parent != null and child != null:
		if parent.grid.x == child.grid.x or parent.grid.y == child.grid.y:
			type = "direct"
		else:
			type = "bend"
			
		match type:
			"direct":
				color = Color.BLACK
			"bend":
				color = Color.WHITE
		
		for track in tracks:
			if track.type == null:
				track.set_type(type)
#endregion