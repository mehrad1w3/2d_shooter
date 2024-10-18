extends CharacterBody2D

@onready var bullet = preload("res://scenes/bullet.tscn")
@onready var animation_sprite_2d = $AnimatedSprite2D
@onready var debug_Label = $debug_Label
@onready var pivotpoint: Marker2D = $AnimatedSprite2D/pivotpoint

const gravity: float = 1000.0
var walk_speed: float = 200.0
const run_speed_multiplier = 1.6

var is_aiming = false  # Flag to track aiming state
var is_firing = false  # Flag to track firing state

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += gravity * delta
        
    get_input()
    move_and_slide()

func get_input() -> void:
    velocity.x = 0
    
    if Input.is_action_pressed("left"):
        velocity.x = -walk_speed
        animation_sprite_2d.flip_h = true
        
    elif Input.is_action_pressed("right"):
        velocity.x = walk_speed
        animation_sprite_2d.flip_h = false

    # Run Logic
    if Input.is_action_pressed("run") and velocity.x != 0:
        velocity.x *= run_speed_multiplier 

    # Aim Logic
    if Input.is_action_pressed("aim") and not Input.is_action_pressed("run"):
        is_aiming = true
        is_firing = Input.is_action_pressed("shoot")  # Update is_firing based on pressed state
        if is_firing:
            shootANDanimation()
    else:
        is_aiming = false
        is_firing = false

func shootANDanimation() -> void:
    var bullet_instance = bullet.instantiate()
    pivotpoint.add_child(bullet_instance)

    # Calculate the direction to the mouse position
    var mouse_pos = get_global_mouse_position()
    var direction = (mouse_pos - position).normalized()  # Get direction vector and normalize it

    # Set the bullet's velocity to move towards the mouse position
    bullet_instance.set_direction(direction)