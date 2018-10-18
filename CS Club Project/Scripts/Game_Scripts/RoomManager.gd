extends Node2D

const ROWS = 6
const COLS = 10

var wall
var room
var roomTiles = []

func _ready():
	
	wall = load("res://Scenes/Wall.tscn")
	room_setup()
	
	pass

func room_setup():
	
	initialize_room()
	
	var wallCtr = 0
	
	# loop along X-axis
	for row in range(0, 6):
		for col in range (0, 10):
			var toInstantiate
			
			# Draw walls
			if room[row][col] == 1:
				toInstantiate = wall
				wallCtr += 1
			
			# Instantiate the tile
			if toInstantiate != null:
				var instance = toInstantiate.instance()
				instance.set_name("wall" + String(wallCtr))
				self.add_child(instance)
				instance.position = Vector2(8+ col * 16, 8 +row * 16)
				print(instance.position)
	
	pass

func initialize_room():
	
	room = [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
			[1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]
	
	pass