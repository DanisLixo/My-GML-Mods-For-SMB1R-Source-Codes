extends AnimatedSprite2D

enum STATE {Absent, Entering, Idle, Sit, Sleep, Walk, Test, Exiting}

@export var state := STATE.Absent
var isMouseToPet := false

var direction := 1
var velocity := Vector2(0.5, 0)

var border := Rect2(0, 0, DisplayServer.window_get_size().x, DisplayServer.window_get_size().y)

func _ready() -> void:
	state = STATE.Absent

func _process(delta: float) -> void:
	handle_input()
	handle_sprites()

func _physics_process(delta: float) -> void:
	handle_states(delta)

func handle_sprites() -> void:
	match state:
		STATE.Absent:
			visible = false
		STATE.Entering:
			pass
		STATE.Idle:
			scale.x = direction
			animation = "Idle"
		STATE.Sit:
			animation = "Sit"
		STATE.Walk:
			animation = "Walk"

func handle_states(delta: float) -> void:
	if (state == STATE.Walk):
		position.x += (velocity.x * direction) * delta / delta

func handle_input() -> void:
	if (Input.is_action_just_pressed("mb_left") && isMouseToPet):
		print("Dog petted")
	if (Input.is_action_just_pressed("drop_item")):
		$"../AnimationPlayer".play("TestLevel")

func mouse_area_pet(mouseIn: bool) -> void:
	isMouseToPet = mouseIn
	
	print(str(mouseIn))

func on_timeout() -> void:
	var randInt := randi() % 20
	if (state != STATE.Walk):
		if (randInt >= 8):
			state = [STATE.Walk, STATE.Sit, STATE.Sleep][randi_range(0, 2)]
			
		print("State changed: %s" % str(state))
	else:
		if (randInt >= 20):
			state = [STATE.Idle, STATE.Sit][randi_range(0, 2)]

func on_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "Enter"):
		state = STATE.Idle
		$Timer.start()

func on_area_entered(area: Area2D) -> void:
	if (state == STATE.Walk):
		direction = -direction
