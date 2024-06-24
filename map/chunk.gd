extends Node

class_name Chunk

var position: Vector2i
var data: Dictionary

const CHUNK_SIZE: int = 16

func _init(chunk_pos: Vector2i, noise_data: Dictionary):
	position = chunk_pos
	data = noise_data
	
# converts world coordinates to chunk coordinates
static func world_pos_to_chunk_pos(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		round(world_pos.x * pow(Chunk.CHUNK_SIZE, -2)), 
		round(world_pos.y * pow(Chunk.CHUNK_SIZE, -2))
	)

