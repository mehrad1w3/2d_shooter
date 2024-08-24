extends Sprite2D

const  bulletspeed = 20


func _physics_process(delta: float) -> void:
	position.x += bulletspeed
	
