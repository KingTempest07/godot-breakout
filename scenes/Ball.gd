extends RigidBody2D
class_name  Ball

const BALL = 4
const BLOCK = 8

# We will set the ball in motion and let the 2D physics system do the rest.
# See the README for settings to make this work correctly.

@export var initial_velocity:= 850.0
@export var velocity_increase_on_bounce:= 25.0
@export var max_velocity:= 1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	var rand_angle:= randf_range(3*PI/4, PI/4)
	var direction:= Vector2.from_angle(rand_angle)
	apply_force(direction * initial_velocity)
	
	
func _process(delta: float) -> void:
	# squared for perf (doesnt matter ig, but i like to do it anyways lol)
	if linear_velocity.length_squared() > max_velocity ** 2:
		linear_velocity = linear_velocity.normalized() * max_velocity




func _on_body_exited(body: Node) -> void:
	var layer = body.collision_layer
	if layer == BLOCK:
		body.queue_free()
		linear_velocity += linear_velocity.normalized() * velocity_increase_on_bounce
