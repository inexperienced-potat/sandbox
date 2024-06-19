extends CharacterBody2D

@export var movement_speed = 100

func _physics_process(delta):
	move_and_collide(velocity)

func _process(delta):
	velocity = Input.get_vector("left", "right", "up", "down") * movement_speed * delta 
