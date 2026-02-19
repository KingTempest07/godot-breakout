extends RigidBody2D
class_name  Ball

signal block_destroyed(block: Node2D)
signal player_entered()

const BALL = 4
const BLOCK = 8
const CONTROL_BALL = 32

# We will set the ball in motion and let the 2D physics system do the rest.
# See the README for settings to make this work correctly.

@export var initial_velocity:= 850.0
@export var velocity_increase_on_bounce:= 25.0
@export var max_velocity:= 1000.0
var current_velocity: float


@export
var hue_change_per_bounce: float
@export
var sprite: Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	current_velocity = initial_velocity
	#var rand_angle:= randf_range(3*PI/4, PI/4)
	#var direction:= Vector2.from_angle(rand_angle)
	#linear_velocity = direction * current_velocity
	linear_velocity = Vector2.DOWN * current_velocity
	
	
func _process(delta: float) -> void:
	# squared for perf (doesnt matter ig, but i like to do it anyways lol)
	if linear_velocity.length_squared() > max_velocity ** 2:
		linear_velocity = linear_velocity.normalized() * max_velocity
		current_velocity = max_velocity




func _on_body_exited(body: Node2D) -> void:
	var layer = body.collision_layer
	if layer == BLOCK:
		call_deferred("destroy_block", body)
		current_velocity += velocity_increase_on_bounce
		linear_velocity = linear_velocity.normalized() * current_velocity
		on_bounce()
	if layer == CONTROL_BALL:
		var dir_to_mouse:= (get_global_mouse_position() - global_position).normalized()
		var angle_to_up:= dir_to_mouse.angle_to(Vector2.UP)
		if angle_to_up < -3*PI/8:
			dir_to_mouse = Vector2.from_angle(-PI/8)
		elif angle_to_up > 3*PI/8:
			dir_to_mouse = Vector2.from_angle(-7*PI/8)
		linear_velocity = dir_to_mouse * current_velocity
		on_bounce()
		player_entered.emit()
		
		
func on_bounce():
	var h:= sprite.modulate.h + hue_change_per_bounce
	if h > 1:
		h -= 1
	elif h < 0:
		h += 1
	var color_tween:= create_tween()
	color_tween.tween_property(
		sprite, "modulate", 
		Color.from_hsv(
			h, sprite.modulate.s, sprite.modulate.v, sprite.modulate.a
		), .25
	)
		
		
func destroy_block(block: Node2D):
	block_destroyed.emit(block)
	block.queue_free()
