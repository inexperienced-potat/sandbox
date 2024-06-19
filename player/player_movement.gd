extends CharacterBody2D

@export var movement_speed = 100
var movement_velocity = Vector2(0, 0)

func _ready():
	pass

func _physics_process(delta):
	move_and_collide(movement_velocity)

func _process(delta):
	movement_velocity = Input.get_vector("left", "right", "up", "down") * movement_speed * delta 
	velocity = movement_velocity
