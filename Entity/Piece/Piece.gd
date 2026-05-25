extends CharacterBody2D

var input_dir
const tile := 16
var moving := false

signal end

func _physics_process(_delta: float) -> void:
	input_dir = Vector2.ZERO
	if Input.is_action_just_pressed("Down"):
		input_dir = Vector2.DOWN
		move()
	elif Input.is_action_just_pressed("Left"):
		input_dir = Vector2.LEFT
		move()
	elif Input.is_action_just_pressed("Right"):
		input_dir = Vector2.RIGHT
		move()

func move():
	if input_dir and not moving:
		if stop_move():
			set_physics_process(false)
			set_process(false)
			end.emit()
			return
		var collision = test_move(transform,input_dir*(tile-1))
		if not collision:
			moving = true
			var tween = create_tween()
			tween.tween_property(self,"position",position+input_dir*tile,0.1)
			tween.tween_callback(move_false)

func move_false():
	moving = false

func stop_move():
	return test_move(transform, Vector2.DOWN*(tile-1))
