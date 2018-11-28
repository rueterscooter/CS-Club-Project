extends "res://Scripts/Game_Scripts/MazeManager.gd"

var rows
var cols

var rowPos = 0
var colPos = 0

var visited = false
var walls = [ true, true, true, true ]

var cam

var wallTile
var room
var roomTiles = []

var tileSize

func _ready():
	
	wallTile = load("res://Scenes/Wall.tscn")
	cam = $Cam
	
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
				toInstantiate = wallTile
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
#			Mark walls
			if row == 0 || row == rows - 1 || col == 0 || col == cols - 1:
				room[row].append(1)
				mark_open_doors(row, col)
#			Mark empty space
			else:
				room[row].append(0)
			col += 1
		row += 1
		col = 0
	
	pass

func mark_open_doors(var row, var col):
	
	var midX = int(cols / 2)
	var midY = int(rows / 2)
	
	if !walls[wallDir.top]:
		if row == 0 && (col == midX || (cols % 2 == 0 && col == midX - 1)):
			room[row][col] = 0
	if !walls[wallDir.bot]:
		if row == rows - 1 && (col == midX || (cols % 2 == 0 && col == midX - 1)):
			room[row][col] = 0
	if !walls[wallDir.left]:
		if col == 0 && (row == midY || (rows % 2 == 0 && row == midY - 1)):
			room[row][col] = 0
	if !walls[wallDir.right]:
		if col == cols - 1 && (row == midY || (rows % 2 == 0 && row == midY - 1)):
			room[row][col] = 0
	
	pass

func initialize_cam():
	
	var posX = float(cols / 2) * tileSize
	var posY = float(rows / 2) * tileSize
	
	cam.position.x = posX
	cam.position.y = posY
	
	pass