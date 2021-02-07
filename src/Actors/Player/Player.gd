extends KinematicBody2D
class_name Player

const FLOOR_NORMAL: = Vector2.UP
const DUST_JUMP_SCENE = preload("res://src/Effects/DustParticleJumpEffect.tscn")
const DUST_FALL_SCENE = preload("res://src/Effects/DustParticleFallEffect.tscn")
const REWIND_CLOCK = preload("res://src/Objects/RewindClock.tscn")

export var speed: = Vector2(400.0, 500.0)
export var gravity: = 3500.0
export var max_cayote_time: = 0.1
export var acceleration = 10
export var friction = 10

enum {
	MOVE,
	WALL_GRAB,
	REWIND,
	DEAD
}

var state = MOVE
var velocity: = Vector2.ZERO
var cayote_timer: float
var can_jump: bool = true
var motion_previous: = Vector2()
var hit_the_ground: = false
var previous_position: = Vector2.ZERO
var rewind_timer_placed: bool = false
var check = 0

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var dustJumpPosition = $DustJumpPosition
onready var wallChecker = $WallChecker
onready var brokenParticles = $BrokenParticle
onready var animationState = animationTree.get("parameters/playback")
onready var jumpSound = $Jump
onready var rewindsound = $Rewind

func _ready() -> void:
	animationTree.active = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(delta: float) -> void:
	match state: 
		MOVE:
			move_state(delta)
		WALL_GRAB:
			wall_grab_state(delta)
		REWIND:
			rewind_state(delta)
		DEAD:
			dead_state()

func move_state(delta) -> void:
	
	var is_jump_interrupted: = Input.is_action_just_released("jump") and velocity.y < 0.0
	if Input.is_action_pressed("WallGrab") && wallChecker.is_colliding():
		state = WALL_GRAB
	if Input.is_action_just_pressed("Rewind"):
		check += 1
		rewindsound.play()
		state = REWIND
	var snap = Vector2.DOWN * 32 if !jump_button_pressed() else Vector2.ZERO
	calculate_cayote_time(delta)
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity,direction,speed,is_jump_interrupted)
	motion_previous = velocity
	velocity = move_and_slide_with_snap(velocity,snap,FLOOR_NORMAL)
	squash(direction,delta)
	
func wall_grab_state(delta) -> void:
	sprite.scale = Vector2(1,1)
	animationState.travel("Grab")
	if !Input.is_action_pressed("WallGrab"):
		state = MOVE
	if wallChecker.is_colliding():
		if Input.is_action_pressed("Up"):
			velocity.y = -50
			animationState.travel("Climb")
		elif Input.is_action_pressed("Down"):
			velocity.y = 50
			animationState.travel("Climb")
		else:
			velocity.y = 0
	else:
		state = MOVE
	velocity = move_and_slide(velocity,FLOOR_NORMAL)

func rewind_state(delta) -> void:
	if check == 3:
		check = 1
	if check == 2:
		position = position.move_toward(previous_position,10)
		if position == previous_position:
			state = MOVE
		if Input.is_action_just_pressed("Rewind"):
			state = MOVE
		print("move")
	elif check == 1 :
		var timer = REWIND_CLOCK.instance()
		previous_position = position
		get_parent().add_child(timer)
		timer.global_position = previous_position
		state = MOVE
		print("place")
	velocity = move_and_slide(velocity,FLOOR_NORMAL)

func dead_state():
	animationState.travel("Dead")

func get_direction()-> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if jump_button_pressed() else 0.0)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
		) -> Vector2:
	var out_velocity: = linear_velocity
	out_velocity.y += gravity * get_physics_process_delta_time() #Gravity
	if direction.x != 0:
		animationTree.set("parameters/Run/blend_position",direction.x)
		animationTree.set("parameters/Idle1/blend_position",direction.x)
		animationTree.set("parameters/Fall/blend_position",direction.x)
		animationTree.set("parameters/Jump/blend_position",direction.x)
		animationTree.set("parameters/Grab/blend_position",direction.x)
		animationTree.set("parameters/Climb/blend_position",direction.x)
		animationTree.set("parameters/Dead/blend_position",direction.x)
		animationState.travel("Run")
		out_velocity.x = speed.x * direction.x
	else:
		animationState.travel("Idle1")
		out_velocity.x = 0.0

	if direction.y < 0.0:
		out_velocity.y = speed.y * direction.y
		animationState.travel("Jump")
	if direction.y >= 0.0 && not is_on_floor():
		animationState.travel("Fall")
	if is_jump_interrupted:
		out_velocity.y = 0.0
	return out_velocity

func jump_button_pressed() -> bool:
	if Input.is_action_just_pressed("jump") and can_jump:
		create_jump_dust()
		jumpSound.play()
		return true
	else: return false

func calculate_cayote_time(delta) -> void:
	if is_on_floor():
		can_jump = true
		cayote_timer = 0.0
	else:
		cayote_timer += delta
	if cayote_timer > max_cayote_time:
		can_jump = false

func squash(direction,delta) -> void:
	if not is_on_floor():
		hit_the_ground = false
		sprite.scale.y = range_lerp(abs(velocity.y), 0, abs(speed.y ), 0.75, 1.75)
		sprite.scale.x = range_lerp(abs(velocity.y), 0, abs(speed.y ), 1.25, 0.75)
	if not hit_the_ground and is_on_floor():
		var falldust = DUST_FALL_SCENE.instance()
		get_parent().add_child(falldust)
		falldust.global_position = global_position
		hit_the_ground = true
		sprite.scale.x = range_lerp(abs(motion_previous.y), 0, abs(1700), 1.2, 2.0)
		sprite.scale.y = range_lerp(abs(motion_previous.y), 0, abs(1700), 0.8, 0.5)
	sprite.scale.x = lerp(sprite.scale.x, 1, 0.25 ) # - pow(0.01, delta)
	sprite.scale.y = lerp(sprite.scale.y, 1, 0.25 )
	
func create_jump_dust() -> void:
	var jumpdust = DUST_JUMP_SCENE.instance()
	get_parent().add_child(jumpdust)
	jumpdust.global_position = dustJumpPosition.global_position
	if dustJumpPosition.position.x > 0:
		jumpdust.change_direction_right()
	elif dustJumpPosition.position.x < 0:
		jumpdust.change_direction_left()
	
func cassette_found() -> void:
	Stats.cassettes_collected += 1

func die() -> void:
	brokenParticles.emitting = true

func restart_game() -> void:
	 get_tree().reload_current_scene()
	 Stats.cassettes_collected = 0
	
func _on_VisibilityNotifier2D_screen_exited() -> void:
	state = DEAD
