extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.aspect = ["health", "speed", "attack", "energy"]
	arr.direction = ["up", "right", "down", "left"]


func init_num() -> void:
	num.index = {}
	num.index.shard = 0
	
	num.shard = {}
	num.shard.a = 30
	num.shard.d = num.shard.a * 2 / sqrt(2)
	num.shard.r = num.shard.d / 2
	
	num.tunnel = {}
	num.tunnel.n = 12
	num.tunnel.m = 6


func init_dict() -> void:
	init_neighbor()
	init_corner()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0),
		Vector2( 0,-1)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_corner() -> void:
	dict.order = {}
	dict.order.pair = {}
	dict.order.pair["even"] = "odd"
	dict.order.pair["odd"] = "even"
	var corners = [3,4,6]
	dict.corner = {}
	dict.corner.vector = {}
	
	for corners_ in corners:
		dict.corner.vector[corners_] = {}
		dict.corner.vector[corners_].even = {}
		
		for order_ in dict.order.pair.keys():
			dict.corner.vector[corners_][order_] = {}
		
			for _i in corners_:
				var angle = 2 * PI * _i / corners_ - PI / 2
				
				if order_ == "odd":
					angle += PI/corners_
				
				var vertex = Vector2(1,0).rotated(angle)
				dict.corner.vector[corners_][order_][_i] = vertex


func init_emptyjson() -> void:
	dict.emptyjson = {}
	dict.emptyjson.title = {}
	
	var path = "res://asset/json/.json"
	var array = load_data(path)
	
	for emptyjson in array:
		var data = {}
		
		for key in emptyjson:
			if key != "title":
				data[key] = emptyjson[key]
		
		dict.emptyjson.title[emptyjson.title] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.trainer = load("res://scene/1/trainer.tscn")
	scene.member = load("res://scene/1/member.tscn")
	
	scene.loop = load("res://scene/2/loop.tscn")
	scene.shard = load("res://scene/2/shard.tscn")
	scene.track = load("res://scene/2/track.tscn")


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(32, 32)
	vec.size.number = Vector2(5, 32)
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.bar = Vector2(120, 12)
	vec.size.aspect = Vector2(vec.size.bar.x + vec.size.icon.x, vec.size.icon.y)
	vec.size.shard = Vector2(num.shard.a, num.shard.a)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.bar = {}
	color.bar.health = {}
	color.bar.health.fill = Color.from_hsv(0, 0.9, 0.7)
	color.bar.health.background = Color.from_hsv(0, 0.5, 0.9)
	color.bar.speed = {}
	color.bar.speed.fill = Color.from_hsv(120 / h, 0.9, 0.7)
	color.bar.speed.background = Color.from_hsv(120 / h, 0.5, 0.9)
	color.bar.attack = {}
	color.bar.attack.fill = Color.from_hsv(210 / h, 0.9, 0.7)
	color.bar.attack.background = Color.from_hsv(210 / h, 0.5, 0.9)
	color.bar.energy = {}
	color.bar.energy.fill = Color.from_hsv(60 / h, 0.9, 0.7)
	color.bar.energy.background = Color.from_hsv(60 / h, 0.5, 0.9)
	color.bar.experience = {}
	color.bar.experience.fill = Color.from_hsv(210 / h, 0.9, 0.7)
	color.bar.experience.background = Color.from_hsv(210 / h, 0.5, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
