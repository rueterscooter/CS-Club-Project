extends Node2D

var player
var mazeManager
var roomManager

export var mazeSize = 5
export var roomSizeX = 10
export var roomSizeY = 6

var tileSize = 16

var currentRoom

func _ready():
	
	player = load("res://Scenes/Player.tscn")
	mazeManager = $MazeManager
	roomManager = load("res://Scenes/RoomManager.tscn")
	
	instantiate_maze()
	instantiate_player()
	
	pass

func _process(delta):
	
#	change_room_cam()
	
	pass

func instantiate_maze():
	
	mazeManager.size = mazeSize
	
	var rooms = []
	
	var row = 0
	var col = 0
	
	while row < mazeSize:
		rooms.append([])
		while col < mazeSize:
			instantiate_room(rooms, row, col)
			col += 1
		row += 1
		col = 0
	
	mazeManager.rooms = rooms
	
	mazeManager.maze_setup()
	currentRoom = $MazeManager/MazeHolder/Start
	
	pass

func instantiate_room(var rooms, var row, var col):
	
	rooms[row].append(roomManager.instance())
	$MazeManager/MazeHolder.add_child(rooms[row][col])
	rooms[row][col].set_name("room")
	rooms[row][col].rows = roomSizeY
	rooms[row][col].cols = roomSizeX
	rooms[row][col].tileSize = tileSize
	rooms[row][col].rowPos = row
	rooms[row][col].colPos = col
	rooms[row][col].position = Vector2(col * roomSizeX, row * roomSizeY) * tileSize
	
	pass

func instantiate_player():
	
	var midX = $MazeManager/MazeHolder/Start.global_position.x + (roomSizeX * tileSize / 2)
	var midY = $MazeManager/MazeHolder/Start.global_position.y + (roomSizeY * tileSize / 2)
	
	var playerInstance = player.instance()
	self.add_child(playerInstance)
	playerInstance.set_name("Player")
	playerInstance.global_position = Vector2(midX, midY)
	
	pass

func change_room_cam():
	
#	Player exits top
	if $Player/KinematicBody2D.global_position.y < currentRoom.global_position.y:
		currentRoom.get_child(0).current = false
		currentRoom = mazeManager.rooms[currentRoom.rowPos - 1][currentRoom.colPos]
		currentRoom.get_child(0).current = true
#	Player exits bottom
	elif $Player/KinematicBody2D.global_position.y > currentRoom.global_position.y + (roomSizeY * tileSize):
		currentRoom.get_child(0).current = false
		currentRoom = mazeManager.rooms[currentRoom.rowPos + 1][currentRoom.colPos]
		currentRoom.get_child(0).current = true
#	Player exits left
	elif $Player/KinematicBody2D.global_position.x < currentRoom.global_position.x:
		currentRoom.get_child(0).current = false
		currentRoom = mazeManager.rooms[currentRoom.rowPos][currentRoom.colPos - 1]
		currentRoom.get_child(0).current = true
#	Player exits right
	elif $Player/KinematicBody2D.global_position.x > currentRoom.global_position.x + (roomSizeX * tileSize):
		currentRoom.get_child(0).current = false
		currentRoom = mazeManager.rooms[currentRoom.rowPos][currentRoom.colPos + 1]
		currentRoom.get_child(0).current = true
	
	pass

