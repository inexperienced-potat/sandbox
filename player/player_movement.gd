extends CharacterBody2D

signal changed_chunk(new_pos: Vector2i)

@export var movement_speed: float = 100
var direction: Vector2
var chunk_pos: Vector2i = Vector2i(0, 0)
var init: bool = true

func _physics_process(delta):
	velocity = direction * movement_speed * delta
	move_and_collide(velocity)
	check_chunk_pos()
	
func check_chunk_pos():
	if init:
		changed_chunk.emit(chunk_pos)
		init = false
	
	var old_pos: Vector2i = chunk_pos
	var new_pos: Vector2i = Chunk.world_pos_to_chunk_pos(position)
	
	if old_pos != new_pos:
		chunk_pos = new_pos
		changed_chunk.emit(new_pos)

func _process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
