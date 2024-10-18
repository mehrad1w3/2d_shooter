extends Sprite2D

const BULLET_SPEED = 950.0 

var direction: Vector2 = Vector2.ZERO  # Direction to move the bullet

func _ready() -> void:
    # Ensure that the bullet gets removed after some time (to prevent memory leaks)
    await get_tree().create_timer(5.0).timeout 
    queue_free() 

func set_direction(new_direction: Vector2) -> void:
    self.direction = new_direction  # Assign the passed direction to the instance variable
    rotation = direction.angle() - PI / 2  # Rotate to face the direction, adjusting by 90 degrees if needed

func _physics_process(delta: float) -> void:
    position += direction * BULLET_SPEED * delta  # Move the bullet in the set direction