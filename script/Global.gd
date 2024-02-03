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


func init_num() -> void:
	num.index = {}


func init_dict() -> void:
	init_neighbor()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
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


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(32, 32)
	vec.size.number = Vector2(5, 32)
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.bar = Vector2(120, 12)
	vec.size.aspect = Vector2(vec.size.bar.x + vec.size.icon.x, vec.size.icon.y)
	
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