extends CharacterBody2D

@onready var animation_sprite_2d = $AnimatedSprite2D
@onready var debug_Label = $debug_Label

const gravity: float = 1000.0
var walk_speed: float = 200.0
const max_fall: float = 400
const run_speed_multiplier = 1.5

enum player_state {IDEL, WALK, HURT, RUN, AIM_STILL, AIM_WALK}

var _state: player_state = player_state.IDEL
var is_aiming = false  # Flag to track aiming state

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
        # Aim animation and aiming logic should go here
    else:
        is_aiming = false

func calculate_state() -> void:
    if _state == player_state.HURT:
        return
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
