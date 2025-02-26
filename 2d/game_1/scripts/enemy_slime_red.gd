extends CharacterBody2D

@export var player: CharacterBody2D
@export var SPEED: int = 50
@export var CHASE_SPEED: int = 100
@export var ACCELARATION: int = 300

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $AnimatedSprite2D/RayCast2D
@onready var timer: Timer = $Timer

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2

enum States {
	WANDER,
	CHASE
}

var current_state = States.WANDER

const LEFT_BOUNDS_OFFSET: Vector2 = Vector2(-100, 0)
const RIGHT_BOUNDS_OFFSET: Vector2 = Vector2(100, 0)

func _ready():
	left_bounds = self.position + LEFT_BOUNDS_OFFSET
	right_bounds = self.position + RIGHT_BOUNDS_OFFSET

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	change_direction()
	look_for_player()

func look_for_player():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider == player:
			chase_player()
		elif current_state == States.CHASE:
			stop_chase()
	elif current_state == States.CHASE:
		stop_chase()

func chase_player() -> void:
	timer.stop()
	current_state = States.CHASE

func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()

func handle_movement(delta: float) -> void:
	if current_state == States.WANDER:
		velocity = velocity.move_toward(direction * SPEED, ACCELARATION * delta)
	else:
		velocity = velocity.move_toward(direction * CHASE_SPEED, ACCELARATION * delta)
	
	move_and_slide()

func change_direction() -> void:
	if current_state == States.WANDER:
		if !animated_sprite.flip_h:
			# moving right
			if self.position.x <= right_bounds.x:
				direction = Vector2(1, 0)
			else:
				# flip to moving left
				animated_sprite.flip_h = true
				ray_cast.target_position = LEFT_BOUNDS_OFFSET
		else:
			# moving left
			if self.position.x >= left_bounds.x:
				direction = Vector2(-1, 0)
			else:
				# flip to moving right
				animated_sprite.flip_h = false
				ray_cast.target_position = RIGHT_BOUNDS_OFFSET
	else:
		# change state. Follow player
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			# flip to moving right
			animated_sprite.flip_h = false
			ray_cast.target_position = RIGHT_BOUNDS_OFFSET
		else:
			# flip moving to left
			animated_sprite.flip_h = true
			ray_cast.target_position = LEFT_BOUNDS_OFFSET

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_timer_timeout() -> void:
	current_state = States.WANDER
