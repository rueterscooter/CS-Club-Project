extends Node2D

export var rows = 6
export var cols = 10
export var tileSize = 16

var cam

var wall
var room
var roomTiles = []

func _ready():
	
	wall = load("res://Scenes/Wall.tscn")
	cam = $Cam
	room_setup()
	
	pass

func room_setup():
	
	initialize_room()
	
	var wallCtr = 0
	
	# loop along X-axis
	for row in range(0, rows):
		for col in range (0, cols):
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
				instance.position = Vector2((tileSize / 2) + col * tileSize, (tileSize / 2) + row * tileSize)
	
	initialize_cam()
	
	pass

func initialize_room():
	
	room = []
	
	var row = 0
	var col = 0
	
	while row < rows:
		room.append([])
		while col < cols:
			if row == 0 || row == rows - 1 || col == 0 || col == cols - 1:
				room[row].append(1)
			else:
				room[row].append(0)
			col += 1
		row += 1
		col = 0
	
	pass

func initialize_cam():
	
	var posX = float(cols / 2) * tileSize
	var posY = float(rows / 2) * tileSize
	
	cam.position.x = posX
	cam.position.y = posY
	
	pass