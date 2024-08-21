extends Node2D
@onready var player = $player
@onready var player_camera = $playercam

func _ready() -> void:
    pass

func _physics_process(delta):
    player_camera.position = player.position