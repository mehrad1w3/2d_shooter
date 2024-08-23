extends CharacterBody2D
@onready var bullet = preload("res://scenes/bullet.tscn")
@onready var animation_sprite_2d = $AnimatedSprite2D
@onready var debug_Label = $debug_Label

const gravity: float = 1000.0
var walk_speed: float = 200.0
const max_fall: float = 400
const run_speed_multiplier = 1.6

enum player_state {IDEL, WALK, HURT, RUN, AIM_STILL, AIM_WALK, AIMING,SHOT}

var _state: player_state = player_state.IDEL
var is_aiming = false  # Flag to track aiming state
var is_firing = false  # Flag to track firing state

func _physics_process(delta: float) -> void:
	if is_on_floor() == false:
		velocity.y += gravity * delta
	get_input()
	move_and_slide()
	calculate_state()
	update_debug_label()



func update_debug_label() -> void:
	debug_Label.text = "floor:%s\n%s\n%.0f" % [
		is_on_floor(),
		player_state.keys()[_state],
		velocity.x,
	]

func get_input() -> void:
	velocity.x = 0
	
	if Input.is_action_pressed("left") == true:
		velocity.x = -walk_speed
		animation_sprite_2d.flip_h = true
		
	elif Input.is_action_pressed("right") == true:
		velocity.x = walk_speed
		animation_sprite_2d.flip_h = false

	# Run Logic
	if Input.is_action_pressed("run") == true:
		if velocity.x != 0:
			velocity.x *= run_speed_multiplier 

	# Aim Logic (independent of movement, but only when not running)
	if Input.is_action_pressed("aim") and not Input.is_action_pressed("run"):
		is_aiming = true
		is_firing = Input.is_action_pressed("shoot")
		if is_firing:
			shootanimation() # Call shoot() when is_firing is true
	else:
		is_aiming = false
		is_firing = false
	# ... (rest of your get_input() function)

	# Aim Logic (independent of movement, but only when not running)
	if Input.is_action_pressed("aim") and not Input.is_action_pressed("run"):
		is_aiming = true
		# Play shot animation here
		is_firing = Input.is_action_pressed("shoot")  # Update is_firing based on pressed state
	else:
		is_aiming = false
		is_firing = false


func calculate_state() -> void:
	if _state == player_state.HURT:
		return

	# Check for firing state first
	if is_firing:
		set_state(player_state.SHOT)
		return  # Exit the function immediately after setting the SHOT state

	if is_on_floor() == true:
		if is_aiming:  # Check for aiming state first
			if velocity.x == 0:  
				set_state(player_state.AIM_STILL)
			else:
				set_state(player_state.AIM_WALK)
		elif velocity.x == 0:
			set_state(player_state.IDEL)
		elif Input.is_action_pressed("run"):
			set_state(player_state.RUN)
		else:
			set_state(player_state.WALK)


	# New logic for firing state
	if is_firing:  # Check if is_firing is true, regardless of aiming
		set_state(player_state.SHOT)
	elif is_aiming:
		if velocity.x == 0:  
			set_state(player_state.AIM_STILL)
		else:
			set_state(player_state.AIM_WALK)


func set_state(new_state: player_state) -> void:
	if new_state == _state:
		return
	_state = new_state

	match _state:
		player_state.IDEL:
			animation_sprite_2d.play("idel")
		player_state.HURT:
			animation_sprite_2d.play("hurt")
		player_state.WALK:
			animation_sprite_2d.play("walk")
		player_state.RUN:
			animation_sprite_2d.play("run")
		player_state.AIM_STILL:
			animation_sprite_2d.play("aim_still")
		player_state.AIM_WALK:
			animation_sprite_2d.play("aim_walk")
		player_state.AIMING:
			animation_sprite_2d.play("aim")
		player_state.SHOT:
			animation_sprite_2d.play("shot")
func shootanimation() -> void:
	set_state(player_state.SHOT) 
	var bullet_instance = bullet.instantiate()
	add_child(bullet_instance)
	
