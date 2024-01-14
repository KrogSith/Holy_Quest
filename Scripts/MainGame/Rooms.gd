extends Node2D


const START_ROOMS : Array = [preload('res://Scenes/Levels/StartRooms/start_room_0.tscn'), 
preload('res://Scenes/Levels/StartRooms/start_room_1.tscn')]
const INTERMEDIATE_ROOMS : Array = [preload('res://Scenes/Levels/Intermediate/room_0.tscn'),
preload('res://Scenes/Levels/Intermediate/room_1.tscn')]
const END_ROOMS : Array = [preload('res://Scenes/Levels/EndRooms/end_room_0.tscn')]

const TILE_SIZE = 16

const LEFT_WALL_TILE = Vector2i(4, 5)
const RIGHT_WALL_TILE = Vector2i(3, 5)
const FLOOR_TILE = Vector2i(2, 1)

@export var num_levels = 5
@onready var player: CharacterBody2D = get_tree().current_scene.get_node('Player')


func _ready():
	spawn_rooms()


func spawn_rooms():
	var previous_room : Node2D
	
	for i in num_levels:
		var room : Node2D
		if i == 0:
			room = START_ROOMS[randi()%START_ROOMS.size()].instantiate()
			player.global_position = room.get_node('PlayerSpawn').global_position
		else:
			if i == num_levels-1:
				room = END_ROOMS[randi()%END_ROOMS.size()].instantiate()
			else:
				room = INTERMEDIATE_ROOMS[randi()%INTERMEDIATE_ROOMS.size()].instantiate()
			var previous_room_tilemap : TileMap = previous_room.get_node('TileMap')
			var previous_room_door : StaticBody2D = previous_room.get_node('Doors/Door')
			var exit_tile_pos : Vector2 = previous_room_tilemap.local_to_map(previous_room_door.position) + Vector2i.UP * 2
			var corridor_height = randi()%5+2
			#print(corridor_height)
			for y in corridor_height:
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2(-2, -y), 0, LEFT_WALL_TILE, 0)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2(-1, -y), 0, FLOOR_TILE, 0)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2(0, -y), 0, FLOOR_TILE, 0)
				previous_room_tilemap.set_cell(0, exit_tile_pos + Vector2(1, -y), 0, RIGHT_WALL_TILE, 0)
			var room_tilemap = room.get_node('TileMap')
			print(room_tilemap.local_to_map(room.get_node('Entrance/Marker2D2').global_position).x)
			room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * (corridor_height+1) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(room.get_node('Entrance/Marker2D2').global_position).x * TILE_SIZE
			#room.position = previous_room_door.global_position + Vector2.UP*room_tilemap.get_used_rect().size.y*TILE_SIZE + Vector2.UP*(1+corridor_height)*TILE_SIZE + Vector2.LEFT*room_tilemap.local_to_map(room.get_node('Entrance/Marker2D2').position).x * TILE_SIZE
		add_child(room)
		previous_room = room






