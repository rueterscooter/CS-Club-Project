extends Node2D

var size

var wallDir = { "top":0,
				"bot":1,
				"left":2,
				"right":3 }

var rooms

var startRow = 0
var startCol = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func maze_setup():
	
	generate_maze()
#	$MazeHolder/Start/Cam.current = true
	for row in rooms:
		for room in row:
			room.room_setup()
	
	pass

func generate_maze():
	
	randomize()
	
	var stack = []
	var endRoomPlaced = false
#	Have all walls in your maze intact (not broken).
	reset_rooms()
	
#	Choose a random start point, push it into the stack. Call this initial square 'current square'.
	startRow = randi() % size
	startCol = randi() % size
	var curRoom = rooms[startRow][startCol]
	curRoom.set_name("Start")
	stack.append(curRoom)
	
#	Repeat while the stack is not empty:
	while stack.size() > 0:
		randomize()
#		Get list of all neighboring squares to the current square where those neighbors have all their walls intact (unvisited).
		var neighbors = get_unvisited_neighbors(curRoom)
#		If there are neighbors (i.e., List.Size > 0):
		if neighbors.size() > 0:
#			Choose one of the neighbors at random. Call it 'temp'.
			var temp = neighbors[randi() % neighbors.size()]
#			Knock the wall between 'temp' and the current square.
			knock_down_walls(curRoom, temp)
#			Push the current square into the stack.
			curRoom.visited = true
			stack.append(curRoom)
#			Make the current square equals 'temp'.
			curRoom = temp
#		Else if there are no neighbors
		else:
			if !endRoomPlaced:
				curRoom.set_name("End")
				endRoomPlaced = true
#				curRoom.visible = false
#			Pop a square from the stack. Make current square equal to it.
			curRoom.visited = true
			curRoom = stack.back()
			stack.pop_back()
	
	pass

func reset_rooms():
	
	for row in rooms:
		for col in row:
			for wall in col.walls:
				wall = true
	
	pass

func get_unvisited_neighbors(var room):
	
	var neighborsList = []
	
#	top
	if room.rowPos > 0 && !rooms[room.rowPos - 1][room.colPos].visited:
		neighborsList.append(rooms[room.rowPos - 1][room.colPos])
#	bottom
	if room.rowPos < size - 1 && !rooms[room.rowPos + 1][room.colPos].visited:
		neighborsList.append(rooms[room.rowPos + 1][room.colPos])
#	left
	if room.colPos > 0 && !rooms[room.rowPos][room.colPos - 1].visited:
		neighborsList.append(rooms[room.rowPos][room.colPos - 1])
#	right
	if room.colPos < size - 1 && !rooms[room.rowPos][room.colPos + 1].visited:
		neighborsList.append(rooms[room.rowPos][room.colPos + 1])
	
	return neighborsList

func knock_down_walls(var room, var neighbor):
	
#	if neighbor is on top
	if neighbor.rowPos < room.rowPos:
		room.walls[wallDir.top] = false
		neighbor.walls[wallDir.bot] = false
#	if neighbor is on bottom
	if neighbor.rowPos > room.rowPos:
		room.walls[wallDir.bot] = false
		neighbor.walls[wallDir.top] = false
#	if neighbor is on the left
	if neighbor.colPos < room.colPos:
		room.walls[wallDir.left] = false
		neighbor.walls[wallDir.right] = false
#	if neighbor is on the right
	if neighbor.colPos > room.colPos:
		room.walls[wallDir.right] = false
		neighbor.walls[wallDir.left] = false
	
	pass