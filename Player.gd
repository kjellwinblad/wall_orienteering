extends KinematicBody

var speed : Vector3 = Vector3(0,0,0)
const jump_speed : int = 7
const gravity : float = 9.8
const turn_speed : float = 3.0
const forward_speed: float = 8.0
export(float) var mouse_sensetivity = 20000

onready var run_sound_player = $AudioStreamPlayer
var is_playing_run_sound = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	look(event)

func look(event : InputEvent):
	var mouse_event : InputEventMouseMotion = event as InputEventMouseMotion
	if mouse_event:
		var pos : Vector2 = mouse_event.relative
		self.rotation_degrees.y += -1*pos.x * mouse_sensetivity
		var camera : Camera = $Camera2
		if camera.current:
			camera.rotation_degrees.x += -1*pos.y * mouse_sensetivity
			if camera.rotation_degrees.x > 80.0:
				camera.rotation_degrees.x = 80.0
			if camera.rotation_degrees.x <  -80.0:
				camera.rotation_degrees.x = -80.0

func _physics_process(delta):
	var direction : Vector3 = Vector3(0,0,0)
	if Input.is_action_pressed("move_north"):
		direction.z -= 1
	if Input.is_action_pressed("move_south"):
		direction.z += 1
	if Input.is_action_pressed("move_west"):
		direction.x -= 1
	if Input.is_action_pressed("move_east"):
		direction.x += 1
	if Input.is_action_pressed("turn_left"):
		rotate_y(turn_speed*delta)
	if Input.is_action_pressed("turn_right"):
		rotate_y(-turn_speed*delta)
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backwards"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	direction = direction.normalized()
	direction = direction * forward_speed + speed
	direction = direction.rotated(Vector3.UP, rotation.y)
	var on_floor : bool = is_on_floor()
	if Input.is_action_pressed("jump") and on_floor:
		speed.y = jump_speed
	elif not on_floor:
		speed.y -= gravity * delta
	else:
		speed.y = -0.01
	if Vector2(direction.x, direction.z).length() > 2:
		if not is_playing_run_sound:
			is_playing_run_sound = true
			run_sound_player.play()
	else:
		if is_playing_run_sound:
			is_playing_run_sound = false
			run_sound_player.stop()
	move_and_slide(direction, Vector3.UP)


func _on_AudioStreamPlayer_finished():
	if is_playing_run_sound:
		run_sound_player.play()
