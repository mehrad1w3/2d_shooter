extends Sprite2D

const  bulletspeed = 10

func _physics_process(delta: float) -> void:
	position.x += bulletspeed
	
