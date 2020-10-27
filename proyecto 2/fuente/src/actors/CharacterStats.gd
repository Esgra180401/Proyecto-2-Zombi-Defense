extends KinematicBody2D

class_name CharacterStats

export var health: int
export var strenght: int
export var level: int
export var noiseLVL: int
export var atkrange: int

func _physics_process(delta: float) -> void:
	var velocity: = Vector2(0,0)
	move_and_slide(velocity)
