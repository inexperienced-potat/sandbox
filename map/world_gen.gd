extends TileMap

var world_data: Array[Chunk]
var noise: FastNoiseLite = FastNoiseLite.new()
var loaded_chunks: Dictionary

const UNLOAD_CHUNKS_DISTANCE: int = 3
const SURROUNDING_CHUNKS: int = 2

func _ready():
	noise.seed = 12345 #testing value, will be replaced by Time.get_unix_time_from_system()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.005

func generate_chunk(chunk_pos: Vector2i) -> Chunk:
	var noise_data: Dictionary = {}
	
	for y in range(0, Chunk.CHUNK_SIZE):
		for x in range(0, Chunk.CHUNK_SIZE):
			var noise_value = noise.get_noise_2d(Chunk.CHUNK_SIZE * chunk_pos.x + x, Chunk.CHUNK_SIZE * chunk_pos.y + y)
			noise_data[Vector2i(x, y)] = -1 if noise_value < 0 else 1
	
	var chunk: Chunk = Chunk.new(chunk_pos, noise_data)
	return chunk

func draw_chunk(chunk: Chunk) -> void:
	for y in range(0, Chunk.CHUNK_SIZE):
		for x in range(0, Chunk.CHUNK_SIZE):
			#skip border tiles, just for chunk visualisation
			#if x == 0 or x == 15 or y == 0 or y == 15:
			#	continue
			
			var tileset_coords = Vector2i(1, 0) if chunk.data[Vector2i(x, y)] == -1 else Vector2i(0, 0)
			
			set_cell(0, Vector2i(Chunk.CHUNK_SIZE * chunk.position.x + x, Chunk.CHUNK_SIZE * chunk.position.y + y), 0, tileset_coords)
	
func erase_chunk(chunk: Chunk) -> void:
	for y in range(0, Chunk.CHUNK_SIZE):
		for x in range(0, Chunk.CHUNK_SIZE):
			erase_cell(0, Vector2i(Chunk.CHUNK_SIZE * chunk.position.x + x, Chunk.CHUNK_SIZE * chunk.position.y + y))

func write_world_data(path: String):
	# compress world_data
	# save it in a file path
	pass
	
func read_world_data(path: String):
	# read data from a save file at path
	# decompress that data into world_data
	pass

func compress_data():
	# compress world_data and return it
	pass
	
func decompress_data():
	# decompress world_data and return it
	pass

func clear_distant_chunks(chunk_pos: Vector2i) -> void:
	var chunk_positions = loaded_chunks.keys()
	
	for pos: Vector2i in chunk_positions:
		if abs(pos.x - chunk_pos.x) > UNLOAD_CHUNKS_DISTANCE or abs(pos.y - chunk_pos.y) > UNLOAD_CHUNKS_DISTANCE:
			var unloaded_chunk: Chunk = loaded_chunks[pos]
			
			erase_chunk(unloaded_chunk)
			loaded_chunks.erase(pos)
			unloaded_chunk.queue_free()

# this function is called when player emits changed_chunk signal
func _on_player_changed_chunk(new_pos: Vector2i) -> void:
	for y in range(new_pos.y - SURROUNDING_CHUNKS, new_pos.y + SURROUNDING_CHUNKS + 1):
		for x in range(new_pos.x - SURROUNDING_CHUNKS, new_pos.x + SURROUNDING_CHUNKS + 1):
			var chunk_pos: Vector2i = Vector2i(x, y)
			
			if chunk_pos not in loaded_chunks.keys():
				var chunk: Chunk = generate_chunk(chunk_pos)
				
				loaded_chunks[chunk_pos] = chunk
				draw_chunk(chunk)
		
	clear_distant_chunks(new_pos)
