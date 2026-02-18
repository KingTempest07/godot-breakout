extends StaticBody2D

# Script for the player (paddle)

class_name Paddle

signal hit

@export
var sprite: Sprite2D

@export var speed = 800
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	var half_width:= Vector2(sprite.scale.x, 0)
	position = position.clamp(Vector2.ZERO + half_width, screen_size - half_width)
